json.success true
json.data do 
  json.partial! 'v1/challenges/show', challenge: @challenge
end