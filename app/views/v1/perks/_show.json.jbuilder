json.extract! perk, :id, :name, :tagline, :success_label, :description, :price, :amount, :lifespan, :is_percentage
json.icon perk.application.icon 
json.banner perk.application.banner
json.application do 
  json.id perk.application_id 
  json.name perk.application.name
  json.category perk.application.category
end