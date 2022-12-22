json.success true
json.count @user.friends.count
json.data do
  json.partial! 'v1/users/friends', invitations: @user.invitees, friends: @user.friends, suggested_friends: @user.friends_suggestions
end