FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "ueda20460323" }
    password_confirmation { "ueda20460323" }
  end
end
