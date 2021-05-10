require 'sinatra/extension'

module Auth
  class Unauthorized < StandardError; end

  AUTH_TOKEN = %r{\ABearer (?<token>.+)\z}

  def user_id
    user_id = auth_service.auth(matched_token) if matched_token.present?
    raise Unauthorized if user_id.blank?
    user_id
  end

  private

  def auth_service
    @auth_service ||= AuthService::RpcClient.fetch
  end

  def matched_token
    result = auth_header&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end

  def auth_header
    request.env['HTTP_AUTHORIZATION']
  end
end
