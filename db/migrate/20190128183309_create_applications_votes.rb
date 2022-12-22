class CreateApplicationsVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :applications_votes do |t|
      t.references :user, foreign_key: true 
      t.references :potential_application, foreign_key: true

      t.timestamps
    end
  end
end
