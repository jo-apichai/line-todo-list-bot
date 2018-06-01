module Api
  module V1
    class TasksController < BaseController
      def index
        render json: Task.where(user_id: current_user['id'])
      end
    end
  end
end
