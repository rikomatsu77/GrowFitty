class FixNullConstraintsAndColumnTypes < ActiveRecord::Migration[7.2]
  def change
    # NOT NULL制約の追加
    change_column_null :bookmarks, :user_id, false
    change_column_null :bookmarks, :post_id, false
    change_column_null :comments, :user_id, false
    change_column_null :comments, :post_id, false
    change_column_null :comments, :body, false
    change_column_null :posts, :user_id, false
    change_column_null :post_tags, :post_id, false
    change_column_null :post_tags, :tag_id, false

    # カラム型の変更（datetime → date）
    change_column :children, :birthday, :date, null: false
    change_column :measurements, :measured_on, :date
  end
end
