class Child < ApplicationRecord
  belongs_to :user
  has_many :measurements, dependent: :destroy

  validates :name, :gender, :birthday, presence: true
end
