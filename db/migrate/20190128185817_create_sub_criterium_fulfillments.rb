class CreateSubCriteriumFulfillments < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_criterium_fulfillments do |t|
      t.references :resource, polymorphic: true,  index: {:name => "index_crit_fulfillments_on_resource_type_and_resource_id"}
      t.references :sub_criterium, foreign_key: true

      t.timestamps
    end
  end
end
