class ChangeApplicationAuthStoring < ActiveRecord::Migration[5.2]
  def change
    rename_column :applications, :public_key, :api_public_key
    rename_column :applications, :private_key, :api_private_key
    add_column :applications, :sandbox_public_key, :string
    add_column :applications, :sandbox_private_key, :string
    add_column :applications, :api_client_id, :string
  end
end
