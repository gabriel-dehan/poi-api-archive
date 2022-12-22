class AddTaglineToProjectAndPerks < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :tagline, :string 
    add_column :perks, :tagline, :string     
  end
end
