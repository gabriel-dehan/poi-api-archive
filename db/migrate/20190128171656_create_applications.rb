class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :category, null: false
      t.string :video_url
      t.text :public_key
      t.text :private_key
      t.string :access_token
      t.string :android_url
      t.string :ios_url
      t.string :web_url
      t.boolean :is_observed, default: true, null: false

      t.timestamps
    end
  end
end
