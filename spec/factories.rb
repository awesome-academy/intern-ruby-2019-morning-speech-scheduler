FactoryBot.define do
  factory :calendar do
    day{Time.zone.now}
    tag{"speech"}
    association :user
  end

  factory :user do
    sequence(:name){|n| "Phu-#{n}" }
    sequence(:email){|n| "test-#{n}@test.com" }
    password{"123456"}
    admin{false}
    group_id{nil}
  end
end
