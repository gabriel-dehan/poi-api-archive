class AddCelebratorySights < ActiveRecord::Migration[5.2]
  def change
    add_column :impacts, :levels_celebratory_sights, :json, default: {} 
  end
end
