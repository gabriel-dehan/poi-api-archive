class ChangeUsersReferrerIdToReference < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :referrer_id 
    add_reference :users, :referrer, foreign_key: { to_table: "users" }
  end
end
