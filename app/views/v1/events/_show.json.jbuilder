json.id event.id 
json.type event.type 
json.title event.title
json.icon event.icon
json.user do 
  json.id event.user.id 
  json.email event.user.email 
end
if event.application
  json.application event.application, partial: 'v1/applications/show', as: :application
end
json.category event.category 
json.earned_points event.earned_points.floor
json.date event.datetime
