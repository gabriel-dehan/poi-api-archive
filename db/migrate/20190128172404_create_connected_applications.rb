class CreateConnectedApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :connected_applications do |t|
      t.string :email, null: false
      t.string :encrypted_password # Only needed for observed applications
      t.references :application, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
