class AddRequestedPermissionsToApplications < ActiveRecord::Migration[5.2]
  def change
    remove_column :applications, :access_token
    add_column :applications, :requested_permissions, :json
  end
end
