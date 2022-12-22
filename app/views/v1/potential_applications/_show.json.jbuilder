json.id potential_app.id 
json.name potential_app.name
json.icon potential_app.icon
if user
  json.has_voted user.has_wished_for(potential_app)
end