class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy, :delete]
  before_action :logged_in_user

  def index
    @incomplete_tasks = current_user.tasks.where(complete: false).order("updated_at desc").page(params[:page])
    @complete_tasks = current_user.tasks.where(complete: true).order("updated_at desc").page(params[:page])
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
  
    respond_to do |format|
      if @task.save
        format.js do
          render 'create', status: :created
        end
      else
        format.js { render 'new', status: :unprocessable_entity }
      end 
    
    end 
  end

  def update
    @task.toggle!(:complete)
  
    respond_to do |format|
      format.js{ 
        @incomplete_tasks = current_user.tasks.where(complete: false).order("updated_at desc").page(params[:page])
        @complete_tasks = current_user.tasks.where(complete: true).order("updated_at desc").page(params[:page])
      }
    end
  end

  def delete
  end

  def destroy
    @task.destroy
  
    respond_to do |format|
      format.js
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
