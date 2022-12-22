class AddCanChallengeToGaugeCycles < ActiveRecord::Migration[5.2]
  def change
    add_column :gauge_cycles, :can_challenge, :boolean, default: false
  end
end
