require 'securerandom'

require_relative 'rpc_api'

module AuthService
  class RpcClient
    extend Dry::Initializer[undefined: false]
    include RpcApi

    attr_accessor :response

    option :queue, default: proc { create_queue }

    option :reply_queue, default: proc {
      create_reply_queue
    }

    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    def self.fetch
      Thread.current['auth_service.rpc_client'] ||= new.start
    end

    def start
      that = self

      @reply_queue.subscribe do |delivery_info, prop, payload|
        if prop[:correlation_id] == @correlation_id
          that.response = payload
          @lock.synchronize { @condition.signal }
        end
      end

      self
    end

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMq.channel
      channel.queue('auth', durable: true)
    end

    def create_reply_queue
      channel = RabbitMq.channel
      channel.queue('amq.rabbitmq.reply-to')
    end

    def publish(payload, opts = {})
      self.correlation_id = SecureRandom.uuid

      @lock.synchronize do
        @queue.publish(
          payload,
          opts.merge(
            app_id: 'geocoder',
            correlation_id: @correlation_id,
            reply_to: @reply_queue.name
          )
        )
        @condition.wait(@lock)
      end
    end
  end
end
