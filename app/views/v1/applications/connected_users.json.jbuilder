json.count @users_connections.count
json.data @users_connections do |connection|
  user = connection.user

  json.connected connection.connected?
  json.application_id connection.application_id
  json.application_name connection.application.name 
  json.user_id connection.user_id
  json.email connection.email
  json.encrypted_password connection.encrypted_password
end