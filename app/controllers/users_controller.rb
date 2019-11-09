class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit)

  def show; end

  def edit; end

  private

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t ".error"
    redirect_to root_path
  end
end
