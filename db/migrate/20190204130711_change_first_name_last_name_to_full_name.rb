class ChangeFirstNameLastNameToFullName < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :first_name 
    rename_column :users, :last_name, :full_name
  end
end
