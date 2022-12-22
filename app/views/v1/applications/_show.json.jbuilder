json.id application.id 
json.name application.name 
json.uid application.uid
json.tagline application.tagline
json.category application.category
json.category_label I18n.t("categories.#{application.category}.title")
json.description application.description 
json.rating application.rating 
json.video_url application.video_url 
json.icon application.icon
json.banner application.banner
json.pictures application.pictures 
json.android_url application.android_url 
json.ios_url application.ios_url 
json.web_url application.web_url 
json.requested_permissions application.requested_permissions
json.poi_earn_tagline application.poi_earn_tagline
json.is_observed application.is_observed
json.config do |config|
  json.auth do
    json.needs_password application.config["auth"]["needs_password"]
    json.auth_providers application.config["auth"]["auth_providers"]
    json.reset_password_link application.config["auth"]["reset_password_link"] # TODO: Document
  end
end

json.created_at application.created_at 
json.updated_at application.updated_at 

if has_internal_access? && has_private_access?
  json.config application.config
  json.connected_applications application.connected_applications
end
