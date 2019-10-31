class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token

  PASSWORD_PARAMS = %i(password password_confirmation).freeze
  UPDATE_PARAMS = %i(name).freeze

  validates :name, presence: true,
    length: {minimum: Settings.user.name.min_length,
      maximum: Settings.user.name.max_length}
  validates :password, presence: true,
    length: {minimum: Settings.user.password.min_length,
      maximum: Settings.user.password.max_length}

  has_secure_password

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end

      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest.present?

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update remember_digest: nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def sent_password_reset
    UserMailer.password_reset(self).deliver_now
  end

  def check_expired?
    reset_sent_at < Settings.user.expired.hours.ago
  end
end
