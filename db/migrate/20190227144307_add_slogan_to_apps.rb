class AddSloganToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :tagline, :text 
    add_column :applications, :poi_earn_tagline, :text 
  end
end
