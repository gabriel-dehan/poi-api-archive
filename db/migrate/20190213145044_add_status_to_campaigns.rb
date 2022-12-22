class AddStatusToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :status, :string, default: "active"
  end
end
