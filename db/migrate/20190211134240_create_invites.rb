class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.string :phone_number
      t.string :full_name
      t.string :status, default: "pending"
      t.references :invitee, references: :users
      t.references :inviter, references: :users
    end

    add_foreign_key :invites, :invites, column: :inviter_id
  end
end
