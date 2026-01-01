FactoryBot.define do
  factory :measurement do
    association :child
    measurement_type { "height" }
    value { 100 }
    measured_on { Date.today }
  end
end
