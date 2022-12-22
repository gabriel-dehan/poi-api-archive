user = @resource
json.data do 
  json.extract! user, :id, :rank, :full_name, :email, :phone_number, :referrer_id, :referral_code, :created_at, :updated_at

  json.impact do
    json.status_uid user.impact.get_status_uid
    json.status user.impact.get_status 
    json.level user.impact.level
    json.server_level_ceiling Impact::GAUGE_LEVELS.keys.last
    json.earned_points user.impact.earned_points.floor
    json.spent_points user.impact.spent_points.floor
    json.current_points user.impact.current_points.floor
    json.last_actions do
      json.partial! 'v1/events/show', collection: user.impact.last_events(3), as: :event
    end
    json.current_cycle do
      json.can_challenge user.can_challenge
      json.launchable_challenge user.launchable_challenge
      json.points user.impact.current_cycle.earned_points.floor
      json.maximum_points user.impact.current_cycle.maximum_points.floor
    end

    json.statuses_list do 
      Impact::GAUGE_LEVELS.each do |level, level_name|
        json.set!(level_name, {
          name: level_name.split("_").map(&:capitalize).join(" "),
          level_threshold: level 
        })
      end
    end
  end

  json.settings do
    json.partial! 'settings', user: user
  end

  json.funded_projects user.campaigns.page(1) do |campaign|
    json.id campaign.id
    json.name campaign.name
    json.amount user.fundings.where(campaign_id: campaign.id).pluck(:amount_cents).sum / 100.0
  end

  json.apps_wishlist PotentialApplication.all do |papp| 
    json.partial! 'v1/potential_applications/show', potential_app: papp, user: user
  end

  json.applications do |app| 
    json.count Application.count
    json.spotlight do 
      json.partial! 'v1/applications/show', collection: Application.spotlight, as: :application
    end
    json.applications do 
      json.partial! 'v1/applications/show', collection: Application.all, as: :application
    end  end

  # json.apps_to_connect user.unconnected_apps.shuffle.take(8) do |app|
  #   json.id app.id
  #   json.name app.name
  #   json.icon app.icon
  #   json.category app.category
  # end

  json.connected_apps user.connected_applications.page(1) do |connection|
    app = connection.application 

    json.id app.id
    json.name app.name
    json.icon app.icon
    json.email connection.email
    json.category app.category
    json.status connection.status
  end

  json.challenges do 
    json.sent user.given_friends_challenges.page(1)  do |challenge|
      json.partial! 'v1/challenges/show', challenge: challenge
    end
    json.received user.received_friends_challenges.page(1)  do |challenge|
      json.partial! 'v1/challenges/show', challenge: challenge
    end
  end

  json.friends do
    json.partial! 'v1/users/friends', invitations: user.invitees.page(1), friends: user.friends.page(1), suggested_friends: user.friends_suggestions
  end

  json.perks do 
    json.partial! 'v1/perks/show', collection: Perk.all.page(1) , as: :perk
  end

  json.projects do 
    json.spotlight do 
      json.partial! 'v1/campaigns/show', collection: Campaign.spotlight, as: :campaign
    end
    json.projects do 
      json.partial! 'v1/campaigns/show', collection: Campaign.all.page(1) , as: :campaign
    end
  end

  json.categories do 
    json.array! Application.all.pluck(:category).uniq.each do |category|
      json.set!(category) do
        json.title I18n.t("categories.#{category}.title")
        json.description I18n.t("categories.#{category}.description")
      end
    end
  end

  json.static_pages do
    json.faq I18n.t("faq")
    json.tos I18n.t("tos")
  end
end
