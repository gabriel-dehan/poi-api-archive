json.data do 
  json.partial! 'show', collection: @perks, as: :perk
end