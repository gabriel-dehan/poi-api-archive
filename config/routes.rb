Rails.application.routes.draw do
  # This is a work-around to properly define rails helpers, see https://github.com/lynndylanhurley/devise_token_auth/issues/908
  # The actual definition of endpoints are in the versions namespace below
  mount_devise_token_auth_for 'User', at: 'auth' 

  # Sidekiq Web UI, only for admins.
  mount Sidekiq::Web => '/sidekiq'

  namespace :forest do
    post '/actions/poi-static-giveaway' => 'users#emit_static_event'
    post '/actions/create-mobility-action' => 'users#create_event'
  end
  mount ForestLiana::Engine => '/forest'
  
  namespace :v1, defaults: { format: :json } do 
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations:  'token_auth/registrations',
      sessions: 'token_auth/sessions'
    }

    post '/log_error', to: "logs#app_logger"
    post '/bug_reported', to: "logs#bug_reported"

    scope :tests, as: :tests do 
      post '/notify/new_app', to: "tests#test_notify"
      post '/notify/level_reached', to: "tests#test_notify_level_reached"
      post '/notify/digest/:id', to: "tests#test_daily_digest"
    end

    scope :users, as: :users do
      get '/count', to: "users#count" 
      get '/', to: "users#index"   
      get '/:id', to: "users#show"
    end
    
    scope :me, as: :me do 
      get '/initial_data', to: "me#initial_data"
      get '/', to: "me#show"
      get '/events', to: "me#events"
      get '/apps', to: "me#applications"
      get '/impacts', to: "me#impacts"
      post '/impacts/trigger_async_refresh', to: "observer#refresh_user_impact"
      
      get '/friends', to: "me#friends"
      post '/contacts/register', to: "me#device_contacts"
      post '/invites', to: "me#create_invite"
      post '/friends/:id', to: "me#add_friend"
      delete '/friends/:id', to: "me#remove_friend"

      get '/challenges', to: "me#challenges"
      post '/challenges', to: "me#challenge_friend"
      put '/challenges/:id/accept', to: "me#accept_challenge"
      put '/challenges/:id/deny', to: "me#deny_challenge"

      get '/perks', to: "me#perks"
      post '/perks', to: "me#select_perk"

      get '/campaigns', to: "me#campaigns"
      post '/fundings', to: "me#fund_campaign"

      post '/apps/create_password', to: "me#reset_app_password"
      post '/apps/reset_password', to: "me#reset_app_password"
      post '/apps/:id', to: "me#connect"
      delete '/apps/:id', to: "me#disconnect"

      put '/settings', to: "me#update_settings"

      put '/wishlist', to: "potential_applications#update_wishlist"
    end

    scope :applications, as: :applications do 
      get '/categories', to: "applications#categories"

      get '/', to: "applications#index"
      get '/:id', to: "applications#show"
      get '/:id/users', to: "applications#connected_users"
    end

    scope :perks, as: :perks do
      get '/', to: "perks#index"
    end

    scope :campaigns, as: :campaigns do
      get '/', to: "campaigns#index"
    end

    scope :potential_applications, as: :potential_applications do
      get '/', to: "potential_applications#index"
      post '/', to: "potential_applications#create"
      post "/:id/vote", to: "potential_applications#vote"
      delete "/:id/vote", to: "potential_applications#unvote"
    end

    scope :events, as: :events do 
      post '/', to: "events#emit"
      post '/batch_emit', to: "events#batch_emit"
    end
  end


end
