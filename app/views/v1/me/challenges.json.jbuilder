json.data do 
  json.sent @user.given_friends_challenges do |challenge|
    json.partial! 'v1/challenges/show', challenge: challenge
  end
  json.received @user.received_friends_challenges do |challenge|
    json.partial! 'v1/challenges/show', challenge: challenge
  end
end