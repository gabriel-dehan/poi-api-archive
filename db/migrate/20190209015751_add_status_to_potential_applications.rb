class AddStatusToPotentialApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :potential_applications, :status, :string, default: "pending"
  end
end
