class ApplicationController < ActionController::Base
  before_action :authenticate_user

  private def authenticate_user
    return if session[:user].present?

    session[:state] = SecureRandom.hex
    session[:nonce] = SecureRandom.hex

    redirect_to LoginService.login_url(session[:state], session[:nonce])
  end
end
