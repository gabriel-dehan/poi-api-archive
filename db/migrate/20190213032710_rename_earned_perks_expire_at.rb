class RenameEarnedPerksExpireAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :earned_perks, :expire_at, :expires_at
  end
end
