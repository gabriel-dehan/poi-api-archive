class RemoveConstraintsGoalFromCampaign < ActiveRecord::Migration[5.2]
  def change
    change_column :campaigns, :goal_cents, :integer, null: true
  end
end
