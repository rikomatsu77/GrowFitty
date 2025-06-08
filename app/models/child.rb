class Child < ApplicationRecord
  belongs_to :user
  has_many :measurements, dependent: :destroy
  accepts_nested_attributes_for :measurements, allow_destroy: true, reject_if: ->(attributes) {
    attributes['value'].blank? && attributes['measured_on'].blank?
    }
  validates :name, :gender, :birthday, presence: true

  # 生年月日が未来でないか
  validate :birthday_cannot_be_in_the_future


  # 最新の身長（測定日の降順で最初のデータ）
  def latest_height
    measurements.where(measurement_type: 'height').order(measured_on: :desc).limit(1).pluck(:value).first
  end

# 最新の体重
  def latest_weight
    measurements.where(measurement_type: 'weight').order(measured_on: :desc).limit(1).pluck(:value).first
  end

# 最新の測定日（身長・体重両方を考慮）
  def latest_measured_on_w
    dates = measurements.where(measurement_type: ['weight']).pluck(:measured_on)
    dates.compact.max
  end

# 最新の測定日（身長・体重両方を考慮）
  def latest_measured_on_h
    dates = measurements.where(measurement_type: ['height']).pluck(:measured_on)
    dates.compact.max
  end


  private

  def birthday_cannot_be_in_the_future
    if birthday.present? && birthday > Date.today
      errors.add(:birthday, "は未来の日付にできません")
    end
  end
end
