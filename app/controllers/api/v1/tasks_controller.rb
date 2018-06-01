module Api
  module V1
    class TasksController < BaseController
      before_action :find_task, only: :update

      def index
        render json: Task.where(user_id: current_user['id'])
      end

      def update
        if @task.update task_params
          render json: @task
        else
          render plain: 'Unprocessable Entity', status: :unprocessable_entity
        end
      end

      private def find_task
        @task = Task.find_by(
          user_id: current_user['id'],
          id: params[:id]
        )
      end

      private def task_params
        params.require(:task).permit(
          :finished,
          :important
        )
      end
    end
  end
end
