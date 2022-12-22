class AddRelationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :impact, foreign_key: true, index: true
    add_reference :users, :users_setting, foreign_key: true
  end
end
