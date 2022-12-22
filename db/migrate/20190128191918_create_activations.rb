class CreateActivations < ActiveRecord::Migration[5.2]
  def change
    create_table :activations do |t|
      t.references :sub_criterium, foreign_key: true
      t.references :event, foreign_key: true
      t.integer :impact_points_cents, default: 0

      t.timestamps
    end
  end
end
