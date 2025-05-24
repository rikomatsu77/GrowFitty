class GrowthStandard < ApplicationRecord
  enum :gender, { male: 0, female: 1 }
  enum :measurement_type, { height: 0, weight: 1 }

  validates :days_since_birth, :gender, :measurement_type, :percentile, :value, presence: true
end
