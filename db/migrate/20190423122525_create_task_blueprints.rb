class CreateTaskBlueprints < ActiveRecord::Migration[5.2]
  def change
    create_table :task_blueprints do |t|
      t.string :type, null: false
      t.string :category, null: false 
      t.string :name, null: false
      t.text :description, null: false
      t.integer :timespan
      t.integer :reward_cents
      t.integer :maximum_occurence
      t.boolean :hidden, default: false
      
      t.timestamps
    end
  end
end
