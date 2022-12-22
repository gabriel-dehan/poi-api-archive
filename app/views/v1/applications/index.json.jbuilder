json.count @applications.count
json.data do 
  json.spotlight do 
    json.partial! 'show', collection: Application.spotlight, as: :application
  end
  json.applications do 
    json.partial! 'show', collection: @applications, as: :application
  end
end