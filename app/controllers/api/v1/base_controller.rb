module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_user

      private def authenticate_user
        return if session[:user].present?

        render plain: 'Unauthorized', status: :unauthorized
      end

      protected def current_user
        @current_user ||= session[:user]
      end
    end
  end
end
