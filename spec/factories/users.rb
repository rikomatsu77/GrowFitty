FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    # OAuth用
    trait :google_oauth do
      provider { "google_oauth2" }
      sequence(:uid) { |n| "google_uid_#{n}" }
      sequence(:email) { |n| "google_user#{n}@example.com" }
    end

    trait :line_oauth do
      provider { "line" }
      sequence(:uid) { |n| "line_uid_#{n}" }
      sequence(:email) { |n| "line-line_uid_#{n}@example.com" }
    end
  end
end
