class UsersController < ApplicationController
  before_action :find_user, only: [:update, :edit, :avatar_new, :avatar_create, :avatar_update]
  before_action :logged_in_user, only: [:edit, :update, :avatar_create, :avatar_update, :avatar_new]
  before_action :correct_user, only: [:edit, :update, :avatar_create, :avatar_update, :avatar_new]

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t('update_successfully')
      redirect_to edit_user_path(@user)
    else
      render :edit
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
