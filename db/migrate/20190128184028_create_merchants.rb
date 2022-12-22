class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name, null: false
      t.string :description
      t.string :email, null: false
      t.string :address, null: false
      t.string :url
      t.string :phone_number
      t.text :opening_hours
      t.text :categories, array: true, default: []
      t.float :latitude
      t.float :longitude
    end
  end
end
