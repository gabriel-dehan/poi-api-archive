class CreateCategorizedImpacts < ActiveRecord::Migration[5.2]
  def change
    create_table :categorized_impacts do |t|
      t.references :impact 
      t.string :category, null: false
      t.integer :level, default: 1
      t.integer :earned_points_cents, default: 0, null: false
    end

    remove_reference :gauge_cycles, :impact
    add_reference :gauge_cycles, :impactable, polymorphic: true
  end
end
