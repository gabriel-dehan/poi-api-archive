class AddCategoryToPotentialApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :potential_applications, :category, :string, null: false
  end
end
