class CreateUsersSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :users_settings do |t|
      t.boolean  :notifications_active, default: true

      t.timestamps
    end
  end
end
