class CreatePerks < ActiveRecord::Migration[5.2]
  def change
    create_table :perks do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price_cents
      t.references :application, foreign_key: true

      t.timestamps
    end
  end
end
