class SessionsController < ApplicationController
  def new
  end

  def create
    if auth = request.env["omniauth.auth"]
      user = User.find_by_omniauth(auth)
      log_in user
      flash[:success] = "GitHub登录成功"
      redirect_to edit_user_path(user)
    else
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = "用户登录成功"
        redirect_to  edit_user_path(user)
      else
        flash.now[:danger] = "邮箱或者密码错误"
        render 'new'
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end
end
