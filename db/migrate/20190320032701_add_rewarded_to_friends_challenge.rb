class AddRewardedToFriendsChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :friends_challenges, :rewarded, :boolean, default: false
  end
end
