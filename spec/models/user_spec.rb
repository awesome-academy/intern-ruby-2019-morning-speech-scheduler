require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    subject{FactoryBot.create :user}

    context "Valid attribute" do
      it{is_expected.to be_valid}
    end

    context "Name invalid presence" do
      it{should validate_presence_of(:name)}
    end

    context "Name invalid min length" do
      it{should validate_length_of(:name).is_at_least(Settings.user.name.min_length)}
    end

    context "Name invalid max length" do
      it{should validate_length_of(:name).is_at_most(Settings.user.name.max_length)}
    end

    context "Email invalid presence" do
      it{should validate_presence_of(:email)}
    end

    context "Email invalid max length" do
      it{should validate_length_of(:email).is_at_most( Settings.user.email.max_length)}
    end

    context "Email invalid format" do
      it{should allow_value("doanphua4@gmail.com").for(:email)}
    end

    context "Email invalid uniqueness" do
      it{should validate_uniqueness_of(:email).ignoring_case_sensitivity}
    end

    context "Password invalid presence" do
      it{should have_secure_password}
    end

    context "Password invalid min lenth" do
      it{should validate_length_of(:password).is_at_least(Settings.user.password.min_length)}
    end

    context "Password invalid max length" do
      it{should validate_length_of(:password).is_at_most(Settings.user.password.max_length)}
    end
  end

  describe "Instance mothods" do
    let!(:user){FactoryBot.create :user}

    context "#remember" do
      before{user.remember}

      it "Remember success" do
        expect(user.remember_digest).not_to be_nil
      end
    end

    context "#forget" do
      before do
        user.remember
        user.forget
      end

      it "Forget success" do
        expect(user.remember_digest).to be_nil
      end
    end

    context "#authenticated?" do
      it "Authenticated true" do
        user.remember
        expect(user.authenticated? "remember", user.remember_token).to be true
      end

      it "Authenticated false" do
        expect(user.authenticated? "remember", user.remember_token).not_to be true
      end
    end

    context "#create_reset_digest" do
      before{user.create_reset_digest}

      it "Create reset digest success" do
        expect(user.reset_digest).not_to be_nil
      end
    end

    context "#check_expired?" do
      it "Check expired true" do
        user.reset_sent_at = Time.zone.now - 3.hours
        expect(user.check_expired?).to be true
      end

      it "check expired false" do
        user.reset_sent_at = Time.zone.now
        expect(user.check_expired?).not_to be true
      end
    end
  end

  describe "Class mothods" do
    context ".new_token" do
      it "new token true" do
        expect(described_class.new_token).not_to be_nil
      end
    end

    context ".digest" do
      it "cretae digest token" do
        expect(described_class.digest(described_class.new_token)).not_to be_nil
      end
    end
  end

  describe "Scope" do
    let!(:user1){FactoryBot.create(:user, last_speech: Time.zone.now)}
    let!(:user2){FactoryBot.create(:user, last_speech: Time.zone.now - 3.hours)}
    let!(:user3){FactoryBot.create(:user, last_speech: Time.zone.now + 3.hours)}
    let!(:user4){FactoryBot.create(:user, admin: true, last_speech: Time.zone.now - 10.hours)}

    context "#last_speech_asc" do
      it{expect(User.all.last_speech_asc).to eq [user4, user2, user1, user3]}
    end
  end

  describe "Associations" do
    context "Has many calendars" do
      it{should have_many(:calendars).dependent(:destroy)}
    end
  end
end
