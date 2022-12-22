class CreateGaugeCycles < ActiveRecord::Migration[5.2]
  def change
    create_table :gauge_cycles do |t|
      t.boolean :current, default: true
      t.references :impact, foreign_key: true
      t.integer :earned_points_cents, default: 0
      t.text :events_ids, array: true, default: []

      t.timestamps
    end
  end
end
