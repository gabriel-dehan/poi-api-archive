class AddPerksPercentageOptionAndAmount < ActiveRecord::Migration[5.2]
  def change
    add_column :perks, :is_percentage, :boolean, default: false
    add_column :perks, :amount, :decimal, default: 0
    add_column :perks, :lifespan, :string, default: "6 months"

    remove_column :earned_perks, :used
    add_column :earned_perks, :status, :string, default: "active" # expired, active or used
    add_column :earned_perks, :expire_at, :datetime
  end
end
