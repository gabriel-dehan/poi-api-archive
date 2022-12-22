json.success true 
json.data do
  json.voter_id @user.id 
  json.potential_application_id @vote.potential_application_id 
  json.name @vote.potential_application.name
end