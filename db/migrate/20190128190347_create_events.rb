class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :type, null: false
      t.references :user, foreign_key: true
      t.references :application, foreign_key: true
      t.datetime :datetime
      t.json :parameters, null: false, default: '{}'
      t.integer :impact_points_cents, default: 0

      t.timestamps
    end
  end
end
