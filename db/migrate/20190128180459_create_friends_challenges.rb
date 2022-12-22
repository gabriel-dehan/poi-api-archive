class CreateFriendsChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :friends_challenges do |t|
      t.references :challenge, foreign_key: true
      t.references :challenger, foreign_key: { to_table: :users }
      t.references :challenged, foreign_key: { to_table: :users }
      t.string :status
      
      t.timestamps
    end
  end
end
