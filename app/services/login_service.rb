class LoginService
  def self.login_url(state, nonce)
    base_url = 'https://access.line.me/oauth2/v2.1/authorize'

    params = {
      response_type: 'code',
      client_id: Rails.application.credentials.line_login[:channel_id],
      redirect_uri: Rails.application.routes.url_helpers.auth_url,
      state: state,
      scope: 'openid profile',
      nonce: nonce
    }

    "#{base_url}?#{params.to_query}"
  end

  def self.get_request_token(code, nonce)
    base_url = 'https://api.line.me/oauth2/v2.1/token'

    channel_id = Rails.application.credentials.line_login[:channel_id]
    channel_secret = Rails.application.credentials.line_login[:channel_secret]

    params = {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: Rails.application.routes.url_helpers.auth_url,
      client_id: channel_id,
      client_secret: channel_secret
    }

    response = RestClient.post base_url, params
    json = JSON.parse(response)

    payload, header = JWT.decode(
      json['id_token'],
      channel_secret,
      true,
      {
        iss: 'https://access.line.me',
        verify_iss: true,
        aud: channel_id.to_s,
        verify_aud: true,
        algorithm: 'HS256'
      }
    )

    raise SecurityError unless payload['nonce'].eql?(nonce)

    payload
  end
end
