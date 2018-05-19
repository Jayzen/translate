class SessionsController < ApplicationController
  def new
  end

  def create
    if auth = request.env["omniauth.auth"]
      user = User.find_by_omniauth(auth)
      log_in user
      flash[:success] = t('github_login_successfully')
      redirect_to edit_user_path(user)
    else
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = t('login_successfully')
        redirect_to  edit_user_path(user)
      else
        flash.now[:danger] = t('email_or_password_error')
        render 'new'
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end
end
