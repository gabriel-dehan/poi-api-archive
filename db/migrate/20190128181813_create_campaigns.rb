class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.text :description
      t.integer :goal_cents, null: false
      t.integer :total_funded_cents, default: 0
      t.datetime :end_date

      t.timestamps
    end
  end
end
