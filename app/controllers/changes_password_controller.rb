class ChangesPasswordController < ApplicationController
  before_action :load_user, :correct_user, only: %i(edit update)

  def edit; end

  def update
    if @user.authenticate(params[:user][:password_old]) && @user.update(update_params)
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash[:danger] = t ".failed"
      render :edit
    end
  end

  private

  def update_params
    params.require(:user).permit User::PASSWORD_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t ".error"
    redirect_to root_path
  end

  def correct_user
    return if current_user? @user
    redirect_to root_url
    flash[:danger]  = t ".not_access"
  end
end
