class ModifyChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :friends_challenges, :challenged_phone_number, :string
    add_column :friends_challenges, :category, :string
    add_column :friends_challenges, :end_date, :datetime
    add_column :friends_challenges, :reward_cents, :integer, default: 0
    add_column :friends_challenges, :goal, :integer, default: 10
    add_column :friends_challenges, :timeframe, :string, default: "1 week"
    remove_reference :friends_challenges, :challenge

    drop_table :challenges
  end
end
