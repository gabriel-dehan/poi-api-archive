class CreateMerchantsQualifications < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants_qualifications do |t|
      t.references :merchant, foreign_key: true
      t.references :quality_label, foreign_key: true

      t.timestamps
    end
  end
end
