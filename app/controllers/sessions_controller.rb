class SessionsController < ApplicationController
  def new; end

  def create
    if logged_in?
      flash[:danger] = t ".many_login"
      redirect_to root_path
    else
      user = User.find_by email: params[:session][:email].downcase

      if user&.authenticate params[:session][:password]
        login_as user
        flash[:success] = t ".success"
        redirect_to root_url
      else
        flash[:danger] = t ".error"
        render :new
      end
    end
  end

  def destroy
    if logged_in?
      logout
      redirect_to root_path
    else
      flash[:warning] = t ".warning"
      redirect_to login_path
    end
  end
end
