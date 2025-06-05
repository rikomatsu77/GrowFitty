class CreateChildren < ActiveRecord::Migration[7.2]
  def change
    create_table :children do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :gender, null: false
      t.datetime :birthday, null: false

      t.timestamps
    end
  end
end
