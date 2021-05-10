module AuthService
  module RpcApi

    def auth(token)
      payload = { token: token }.to_json
      publish(payload, type: 'extract-token')

      JSON(response).dig('user_id')
    end
  end
end
