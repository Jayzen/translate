class SessionsController < ApplicationController
  def new
  end

  def create
    if auth = request.env["omniauth.auth"]
      user = User.find_by_omniauth(auth)
      log_in user
      unless user.categories.find_by(name: "example")
        user.categories.create(name: "example")
      end
      flash[:success] = "GitHub登录成功"
      redirect_to root_path
    else
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.forbidden?
        flash.now[:danger] = "用户已经被禁止"
        render 'new'
      elsif user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = "用户登录成功"
        redirect_to  root_path
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
