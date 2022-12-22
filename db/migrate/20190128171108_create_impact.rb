class CreateImpact < ActiveRecord::Migration[5.2]
  def change
    create_table :impacts do |t|
      t.string :status, default: "baby_poi", null: false
      t.integer :earned_points_cents, default: 0, null: false
      t.integer :spent_points_cents, default: 0, null: false
      t.integer :current_points_cents, default: 0, null: false
    end
  end
end
