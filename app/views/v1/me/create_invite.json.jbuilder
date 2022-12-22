json.success true
json.data do
  json.inviter_id @invitation.inviter_id
  json.invitee_id @invitation.invitee_id
  json.name @invitation.full_name
  json.phone_number @invitation.phone_number
  json.status @invitation.status
end