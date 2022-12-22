class AddChallengedNameToFriendsChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :friends_challenges, :challenged_name, :string
  end
end
