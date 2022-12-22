class AddSuccessLabelToProjectsAndPerks < ActiveRecord::Migration[5.2]
  def change
    add_column :perks, :success_label, :string
    add_column :campaigns, :success_label, :string
  end
end
