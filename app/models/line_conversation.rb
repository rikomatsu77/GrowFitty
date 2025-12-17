class LineConversation < ApplicationRecord
  belongs_to :user, optional: true

  validates :line_user_id, presence: true
  validates :status, presence: true
  
  enum gender: { male: 0, female: 1 }
  enum measurement_type: { height: 0, weight: 1 }

  # 会話をリセットするメソッド
  def reset!
    update!(
      status: "ask_gender",
      gender: nil,
      birth_date: nil,
      measurement_date: nil,
      measurement_type: nil,
      value: nil
    )
  end
end
