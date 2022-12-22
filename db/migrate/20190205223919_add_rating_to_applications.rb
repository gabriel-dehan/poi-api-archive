class AddRatingToApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :rating, :float
  end
end
