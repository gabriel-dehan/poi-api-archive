json.success true 
json.data @user.friends_suggestions do |user| 
  json.partial! 'v1/users/friend', user: user
end