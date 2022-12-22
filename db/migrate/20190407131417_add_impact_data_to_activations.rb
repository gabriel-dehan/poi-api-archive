class AddImpactDataToActivations < ActiveRecord::Migration[5.2]
  def change
    add_column :activations, :impact_data, :json
  end
end
