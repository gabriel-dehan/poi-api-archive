class ChangeInvitesReferences < ActiveRecord::Migration[5.2]
  def change
    remove_reference :invites, :invitee
    remove_reference :invites, :inviter

    add_reference :invites, :invitee, foreign_key: { to_table: :users }
    add_reference :invites, :inviter, foreign_key: { to_table: :users }
  end
end
