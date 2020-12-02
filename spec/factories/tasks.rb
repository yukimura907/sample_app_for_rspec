FactoryBot.define do
  factory :task do
    association  :user 
    sequence(:title, "title_1")
    content { "count drinks" }
    status { "todo" }
    deadline { 1.week.from_now }
  end
end
