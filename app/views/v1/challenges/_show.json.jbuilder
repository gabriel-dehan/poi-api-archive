json.id challenge.id
json.challenger do
  user = challenge.challenger
  json.id user.id 
  json.name user.full_name
  json.email user.email 
  json.phone_number user.phone_number
  json.impact_points user.impact.earned_points.floor
  json.level user.impact.level
  json.status_uid user.impact.get_status_uid
end

json.challenged do 
  user = challenge.challenged 
  if user
    json.id user.id 
    json.name user.full_name
    json.email user.email 
    json.phone_number user.phone_number
    json.impact_points user.impact.earned_points.floor
    json.level user.impact.level
    json.status_uid user.impact.get_status_uid
  else 
    json.id nil 
    json.name (challenge.challenged_name || challenge.challenged_phone_number)
    json.email nil
    json.phone_number challenge.challenged_phone_number
    json.impact_points nil
    json.level nil
    json.status_uid nil
  end
end

json.status challenge.status
json.category challenge.category
json.category_label I18n.t("categories.#{challenge.category}.title")
json.timeframe I18n.t("challenges.timeframes.#{challenge.timeframe.gsub(/\s/, '_')}")
json.created_at challenge.created_at
json.end_date challenge.end_date
json.score challenge.score
json.goal challenge.goal
json.reward challenge.reward

if current_user.applications.where(category: challenge.category).any? 
  apps = current_user.applications.where(category: challenge.category).limit(3)
else
  apps = Application.where(category: challenge.category).limit(3)
end

json.tips apps do |app|
  json.name app.name 
  json.picture app.icon
  json.tip app.random_tip
end
