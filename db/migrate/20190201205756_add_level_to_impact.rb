class AddLevelToImpact < ActiveRecord::Migration[5.2]
  def change
    add_column :impacts, :level, :integer, default: 1
  end
end
