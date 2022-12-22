class AddMaximumPointsToGaugeCycles < ActiveRecord::Migration[5.2]
  def change
    add_column :gauge_cycles, :maximum_points_cents, :integer, default: 0
  end
end
