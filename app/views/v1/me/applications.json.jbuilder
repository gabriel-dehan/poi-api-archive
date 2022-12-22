json.data do 
  json.apps_to_connect @user.unconnected_apps.shuffle.take(8) do |app| 
    json.id app.id
    json.name app.name
    json.icon app.icon
    json.category app.category
  end

  json.connected_apps @connected_apps do |connection| 
    app = connection.application

    json.id app.id
    json.name app.name 
    json.icon app.icon
    json.email connection.email
    json.category app.category
    json.status connection.status
  end
end