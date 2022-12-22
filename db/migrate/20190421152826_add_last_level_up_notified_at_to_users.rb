class AddLastLevelUpNotifiedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_level_up_notified_at, :datetime
  end
end
