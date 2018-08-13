class UsersController < ApplicationController
  before_action :find_user,  only: [:edit, :update, :forbidden]
  before_action :correct_user, only: [:edit, :update]
  before_action :logged_in_user
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save
        @user.categories.create(name: "example")
        format.js do
          @users = User.all
          render 'create', status: :created
        end
      else
        format.js { render 'new', status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "更新成功"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def index
    @users = User.all
  end

  def forbidden
    @user.toggle!(:forbidden)
    
    respond_to do |format|
      format.js
    end
  end

  private
    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,:portrait, :description)
    end
end
