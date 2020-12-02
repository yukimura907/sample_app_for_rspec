FactoryBot.define do
  factory :task do
    association  :user 
    title { "発注" }
    content { "ドリンク全般" }
    status { "todo" }
    deadline { "Fri, 04 Dec 2020 00:06:00 UTC +00:00" }
  end
end
