class ChangeUserNameNullOnUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :user_name, true
  end
end
