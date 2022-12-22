json.success true
json.data do
  json.partial! 'v1/campaigns/show', campaign: @funding.campaign
end