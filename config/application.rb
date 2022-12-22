require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Custom middleware to handle services authentication
require './lib/middlewares/charon'
require './lib/middlewares/charon/handler'
require './lib/middlewares/charon/passenger'
require './lib/middlewares/charon/passenger/internal'

require './lib/threaded_config'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PoiApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_job.queue_adapter = :sidekiq

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    config.middleware.insert_before(Warden::Manager, Charon::Handler)
    config.middleware.insert_before(Charon::Handler, ActionDispatch::Session::CookieStore)
    config.middleware.insert_before(ActionDispatch::Session::CookieStore, ActionDispatch::Cookies)

    config.i18n.default_locale = :fr

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    # Needs to be false otherwise the cookiestore doesn't work
    config.api_only = false
  end
end
