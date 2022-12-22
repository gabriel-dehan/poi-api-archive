class CreateCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :criteria do |t|
      t.string :name, null: false
      t.text :description
      t.string :uid, null: false
      t.string :category, null: false

      t.timestamps
    end
  end
end
