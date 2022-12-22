class CreateSubCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_criteria do |t|
      t.string :uid, null: false
      t.string :name, null: false
      t.text :description
      t.references :criterium, foreign_key: true
      t.json :data, null: false, default: '{}'
      t.text :impact_coefficient 

      t.timestamps
    end
  end
end
