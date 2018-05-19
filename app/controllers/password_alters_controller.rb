class PasswordAltersController < ApplicationController
  before_action :logged_in_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if !@user.authenticate(params[:password_alter][:old_password])
      @user.errors.add(:old_password, t('incorrect_old_password'))
      render 'edit'
    elsif @user.authenticate(params[:password_alter][:old_password]) && params[:password_alter][:old_password] == params[:password_alter][:password]
      @user.errors.add(:password, "不能使用旧密码进行更新!")
      render 'edit'
    elsif params[:password_alter][:password].empty?
      @user.errors.add(:password, t('can_not_be_blank'))
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t('password_reset_successfully')
      redirect_to edit_password_alter_path(@user)
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:password_alter).permit(:old_password, :password, :password_confirmation)
    end
end
