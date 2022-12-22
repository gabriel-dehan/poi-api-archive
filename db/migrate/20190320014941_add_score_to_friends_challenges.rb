class AddScoreToFriendsChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :friends_challenges, :score_cents, :integer, default: 0
  end
end
