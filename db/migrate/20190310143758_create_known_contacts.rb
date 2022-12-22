
class CreateKnownContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :known_contacts do |t|
      t.references :user, foreign_key: true
      t.references :contact, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
