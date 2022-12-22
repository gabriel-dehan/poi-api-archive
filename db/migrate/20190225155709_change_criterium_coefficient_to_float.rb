class ChangeCriteriumCoefficientToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :sub_criteria, :impact_coefficient, 'float USING impact_coefficient::double precision'
  end
end
