class AddStatusToAppsConnections < ActiveRecord::Migration[5.2]
  def change
    add_column :connected_applications, :status, :string, default: "connected"
  end
end
