class RenameReferralInuser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :used_referral_code, :referrer_code
    rename_column :users, :used_referrer_id, :referrer_id
  end
end
