class UpdateEventsParametersToJsonB < ActiveRecord::Migration[5.2]

  def change
    reversible do |dir|
      dir.up { change_column :events, :parameters, 'jsonb USING CAST(parameters AS jsonb)' }
      dir.down { change_column :events, :parameters, 'json USING CAST(parameters AS json)' }
    end
  end
end
