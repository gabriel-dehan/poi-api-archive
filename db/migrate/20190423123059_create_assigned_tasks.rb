class CreateAssignedTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :assigned_tasks do |t|
      t.references :task_blueprint, index: true
      t.references :user, index: true 

      t.integer :completion_count, null: false, default: 0
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
