FactoryBot.define do
  factory :task do
    association  :user 
    sequence(:title) { |n| "title_#{n}" }
    content { "count drinks" }
    status { :todo }
    deadline { 1.week.from_now }
  end
end
