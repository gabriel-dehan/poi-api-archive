class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.string :type, default: "photo"
      t.string :file
      t.references :resource, polymorphic: true

      t.timestamps
    end
  end
end
