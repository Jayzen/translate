class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]
  before_action :logged_in_user
  #skip_before_action :verify_authenticity_token, only: [:update]

  def index
    @incomplete_tasks = current_user.tasks.where(complete: false).order("updated_at desc").page(params[:page])
    @complete_tasks = current_user.tasks.where(complete: true).order("updated_at desc").page(params[:page])
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.create(task_params)
  
    respond_to do |f|
      f.html { redirect_to tasks_url }
      f.js
    end 
  end

  def update
    @task.toggle!(:complete)
  
    respond_to do |f|
      f.html { redirect_to tasks_url }
      f.js
    end
  end

  def destroy
    @task.destroy
  
    respond_to do |f|
      f.html { redirect_to tasks_url }
      f.js
    end
  end

  private

    def task_params
      params.require(:task).permit(:name, :complete)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end
end
