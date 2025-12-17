class CreateLineConversations < ActiveRecord::Migration[7.2]
  def change
    create_table :line_conversations do |t|
      t.string :line_user_id, null: false
      t.string :status, null: false, default: "ask_gender"
      t.integer :gender
      t.date :birth_date
      t.date :measurement_date
      t.integer :measurement_type
      t.float :value

      t.timestamps
      t.references :user, foreign_key: true, null: true
    end
  add_index :line_conversations, :line_user_id
  end
end
