class Measurement < ApplicationRecord
  belongs_to :child
  enum measurement_type: { height: "height", weight: "weight" }

  validates :measurement_type, presence: true
  validates :value, presence: true, numericality: true, if: -> { measured_on.present? }
  validates :measured_on, presence: true, if: -> { value.present? }
end
