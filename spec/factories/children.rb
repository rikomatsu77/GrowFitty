FactoryBot.define do
  factory :child do
    association :user
    name { "太郎" }
    gender { "male" }
    birthday { 5.years.ago.to_date }
  end
end
