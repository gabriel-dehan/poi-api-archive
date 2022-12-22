class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Charon::Authenticate
  include RequiredParams

  include DeviseTokenAuth::Concerns::SetUserByToken
  
  # By default all routes have private access level, it means all requests must provide an API Private Key
  # It can be overriden in any controller with access_level :public, only: [:index, :create, ...]
  access_level :private, unless: :user_auth_controller?
  # Except for user authentication routes, which are handled by devise so we just set them to public
  access_level :public, if: :user_auth_controller?

  # Internal means not destined for the public API and mainly used for poi's own services (the observer, poi app...)
  # By default all endpoints are private. When internal_only is true, the endpoint can only be accessed with the specific Poi Internal API Key and nothing else.
  internal_only true 

  before_action :set_raven_context
  # Most routes are user authenticated, so this is the default, 
  # Use skip_before_action for non authenticated routes
  before_action :authenticate_user!, unless: :user_auth_controller?
  before_action :set_user, unless: :user_auth_controller?

  rescue_from StandardError,                with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def devise_parameter_sanitizer
    User::ParameterSanitizer.new(User, :user, params)
  end

  private
  def set_user 
    @user = current_user
  end

  def not_found(exception)
    render json: { status: "error", errors: [exception.message] }, status: :not_found
  end

  def internal_server_error(exception)
    if Rails.env.development? || ENV['TEST_MODE']
      response = { status: "error", errors: ["#{exception.class.to_s}: #{exception.message}"], backtrace: exception.backtrace, data: {} }
    else
      Raven.capture_exception(exception) # otherwise sentry doesn't capture the errors
      
      response = { status: "error", errors: ["#{exception.message}"] }
    end

    status = if exception.is_a?(ApplicationController::NotAuthorized)
      401
    elsif exception.is_a?(ActionController::BadRequest)
      400
    else
      500
    end

    render json: response, status: status
  end

  def user_auth_controller?
    devise_controller? || params[:controller] =~ /^devise_token_auth/
  end

  def set_raven_context 
    if Rails.env.production? && ENV['TEST_MODE'] # TODO: Improve and create a real staging env
      environment = "staging"
    elsif Rails.env.production? 
      environment = "production"
    else
      environment = "development"
    end

    Raven.user_context(id: current_user&.id) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url, environment: environment)
  end
end
