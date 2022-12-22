class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges do |t|
      t.string :name
      t.text :description
      t.references :application, foreign_key: true
      t.text :categories, array: true, default: []

      t.timestamps
    end
  end
end

