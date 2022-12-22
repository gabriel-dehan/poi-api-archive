json.count @campaigns.count
json.data do 
  json.spotlight do 
    json.partial! 'show', collection: Campaign.spotlight, as: :campaign
  end
  json.projects do 
    json.partial! 'show', collection: @campaigns, as: :campaign
  end
end