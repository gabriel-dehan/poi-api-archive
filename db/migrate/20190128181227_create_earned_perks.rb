class CreateEarnedPerks < ActiveRecord::Migration[5.2]
  def change
    create_table :earned_perks do |t|
      t.references :user, foreign_key: true
      t.references :perk, foreign_key: true
      t.string :use_code, null: false 
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
