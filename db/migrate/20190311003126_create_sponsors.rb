class CreateSponsors < ActiveRecord::Migration[5.2]
  def change
    create_table :sponsors do |t|
      t.references :company, foreign_key: true
      t.references :resource, polymorphic: true

      t.timestamps
    end
  end
end
