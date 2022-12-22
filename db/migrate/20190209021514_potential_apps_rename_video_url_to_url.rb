class PotentialAppsRenameVideoUrlToUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :potential_applications, :video_url, :url
  end
end
