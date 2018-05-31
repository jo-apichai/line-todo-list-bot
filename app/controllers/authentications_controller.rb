class AuthenticationsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :validate_response

  def index
    token = LoginService.get_request_token(params[:code], session[:nonce])

    session[:user] = { id: token['sub'], name: token['name'] }

    session.delete(:state)
    session.delete(:nonce)

    redirect_to root_path
  end

  private def validate_response
    return if params[:error].nil? && params[:state].eql?(session[:state])

    render plain: 'Login was canceled', status: :unauthorized
  end
end
