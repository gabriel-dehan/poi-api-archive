json.success true
json.data do
  json.partial! 'v1/me/show', user: @resource
  json.suggested_applications do 
    json.partial! 'v1/applications/show', collection: Application.all.shuffle, as: :application
  end
end