class CreatePotentialApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :potential_applications do |t|
      t.string :name, null: false
      t.text :description
      t.string :video_url

      t.timestamps
    end
  end
end
