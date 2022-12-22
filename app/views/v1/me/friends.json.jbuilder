json.count @friends.count
json.data do
  json.partial! 'v1/users/friends', invitations: @invitations, friends: @friends, suggested_friends: @suggested_friends
end