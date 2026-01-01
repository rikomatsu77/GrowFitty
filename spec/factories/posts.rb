FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "投稿タイトル#{n}" }
    sequence(:body) { |n| "投稿内容#{n}" }
    association :user
  end
end
