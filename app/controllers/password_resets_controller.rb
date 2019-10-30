class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i(create)
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    if @user
      @user.create_reset_digest
      @user.sent_password_reset
      flash[:info] = t ".success"
      redirect_to root_url
    else
      flash[:danger] = t ".error"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update password_params
      login_as @user
      flash[:success] = t ".success"
      redirect_to root_url
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit User::PASSWORD_PARAMS
  end

  def find_user
    @user = User.find_by email: params[:password_reset][:email].downcase
  end

  def get_user
    @user = User.find_by email: params[:email]

    return if @user
    flash[:danger] = t ".error"
    redirect_to new_password_reset_url
  end

  def valid_user
    return if @user&.authenticated? :reset, params[:id]

    flash[:danger] = t ".not_valid"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.check_expired?

    flash[:danger] = t ".expired"
    redirect_to new_password_reset_url
  end
end
