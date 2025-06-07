class Measurement < ApplicationRecord
  belongs_to :child
  enum measurement_type: { height: "height", weight: "weight" }

  validates :measured_on, :measurement_type, :value, presence: true
end
