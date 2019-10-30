module SessionsHelper
  def login_as user
    session[:user_id] = user.id
  end

  def current_user
    return unless user_id = session[:user_id]

    current_user ||= User.find_by id: user_id
  end

  def logged_in?
    current_user.present?
  end

  def logout
    session.delete :user_id
    current_user = nil
  end
end
