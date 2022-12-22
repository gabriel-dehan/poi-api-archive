class AddConfigToApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :config, :json, default: {}
  end
end
