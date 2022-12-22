json.count @potential_applications.count
json.data do
  json.partial! 'show', collection: @potential_applications, user: current_user, as: :potential_app
end