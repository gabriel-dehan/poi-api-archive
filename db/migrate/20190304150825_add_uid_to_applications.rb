class AddUidToApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :uid, :string
  end
end
