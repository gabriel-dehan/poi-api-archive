json.extract! earned_perk.perk, :id
json.extract! earned_perk.perk, :name, :description, :price, :amount, :is_percentage
json.icon earned_perk.perk.application.icon 
json.banner earned_perk.perk.application.banner
json.use_code earned_perk.use_code
json.expires_at earned_perk.expires_at
json.status earned_perk.status
json.application do 
  json.id earned_perk.perk.application_id 
  json.name earned_perk.perk.application.name
end