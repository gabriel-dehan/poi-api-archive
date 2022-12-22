json.data do 
  json.used do
    json.partial! 'v1/perks/earned_perk', collection: @user.earned_perks.used, as: :earned_perk
  end

  json.active do
    json.partial! 'v1/perks/earned_perk', collection: @user.earned_perks.active, as: :earned_perk
  end
end