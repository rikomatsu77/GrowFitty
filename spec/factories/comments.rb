FactoryBot.define do
  factory :comment do
    body { "コメント本文" }
    association :user
    association :post
  end
end
