class UserMailer < ApplicationMailer
  def password_reset user
    @user = user

    mail to: user.email, subject: t(".title")
  end
end
