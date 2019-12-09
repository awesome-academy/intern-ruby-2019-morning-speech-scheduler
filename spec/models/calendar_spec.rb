require 'rails_helper'

RSpec.describe Calendar, type: :model do
  describe "Scope" do
    let!(:user1){FactoryBot.create(:user, admin: true, last_speech: Time.zone.now)}
    let!(:user2){FactoryBot.create(:user, last_speech: Time.zone.now - 3.hours)}
    let!(:user3){FactoryBot.create(:user, last_speech: Time.zone.now + 3.hours)}
    let!(:user4){FactoryBot.create(:user, admin: true, last_speech: Time.zone.now - 10.hours)}
    let!(:cal1){FactoryBot.create(:calendar, day: Time.zone.now, tag: "speech", user: user1)}
    let!(:cal2){FactoryBot.create(:calendar, day: Time.zone.now + 1.days, tag: "speech", user: user2)}
    let!(:cal3){FactoryBot.create(:calendar, day: Time.zone.now + 2.days, tag: "speech", user: user3)}
    let!(:cal4){FactoryBot.create(:calendar, day: Time.zone.now + 3.days, tag: "speech", user: user4)}
    let!(:cal5){FactoryBot.create(:calendar, day: Time.zone.now, tag: "pending", user: user1)}
    let!(:cal6){FactoryBot.create(:calendar, day: Time.zone.now + 1.days, tag: "absent", user: user1)}
    let!(:cal7){FactoryBot.create(:calendar, day: Time.zone.now + 2.days, tag: "absent", user: user4)}

    context "Calendar follow day decs" do
      it{expect(Calendar.all.day_desc).to eq [cal4, cal7, cal3, cal6, cal2, cal5, cal1]}
    end

    context "Calendar follow tag speech" do
      it{expect(Calendar.all.calendar_speech).to eq [cal1, cal2, cal3, cal4]}
    end
  end

  describe "Associations" do
    context "Belongs to user" do
      it{should belong_to(:user)}
    end
  end
end
