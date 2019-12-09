require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let!(:user){FactoryBot.create :user, admin: true}

  describe "#login_as" do
    it "login with user" do
      expect(login_as user).to eq user.id
    end
  end

  describe "#remember" do
    it "remember with user attribute" do
      remember user
      expect(user.remember_digest).not_to be_nil
    end

    it "remember with cookies" do
      expect(remember user).to eq user.remember_token
    end
  end

  describe "#current_user" do
    it "get current user" do
      login_as user
      expect(current_user).to eq user
    end
  end

  describe "#current_user?" do
    it "check current_user" do
      login_as user
      expect(current_user? user).to be true
    end
  end

  describe "#logged_in?" do
    it "check logged in" do
      login_as user
      expect(logged_in?).to be true
    end
  end

  describe "#forget" do
    it "forget with user attribute" do
      forget user
      expect(user.remember_digest).to be_nil
    end

    it "forget with cookies" do
      expect(forget user).to be_nil
    end
  end

  describe "#logout" do
    before do
      login_as user
      logout
    end

    it "logout with session" do
      expect(session[:user_id]).to be_nil
    end

    it "logout with user" do
      expect(current_user).to be_nil
    end
  end
end
