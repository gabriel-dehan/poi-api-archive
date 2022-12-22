json.friends friends do |friend| 
  json.partial! 'v1/users/friend', user: friend
end

json.invited invitations do |invitation| 
  json.partial! 'v1/users/invitee', invitee: invitation
end

json.suggested_friends suggested_friends do |suggestion| 
  json.partial! 'v1/users/friend', user: suggestion
end
