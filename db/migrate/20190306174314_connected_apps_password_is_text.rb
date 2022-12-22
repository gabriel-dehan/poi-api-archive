class ConnectedAppsPasswordIsText < ActiveRecord::Migration[5.2]
  def change
    change_column :connected_applications, :encrypted_password, :text
  end
end
