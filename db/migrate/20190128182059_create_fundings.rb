class CreateFundings < ActiveRecord::Migration[5.2]
  def change
    create_table :fundings do |t|
      t.references :user, foreign_key: true
      t.references :campaign, foreign_key: true
      t.integer :amount_cents, null: false

      t.timestamps
    end
  end
end
