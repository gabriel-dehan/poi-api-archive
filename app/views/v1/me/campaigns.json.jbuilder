json.data do 
  json.active do
    json.partial! 'v1/campaigns/show', collection: @user.fundings.active.map(&:campaign), as: :campaign
  end

  json.funded do
    json.partial! 'v1/campaigns/show', collection: @user.fundings.funded.map(&:campaign), as: :campaign
  end
end