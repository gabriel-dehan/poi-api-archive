class ConnectedApplication < ApplicationRecord
  paginates_per 20
  max_paginates_per 20
  
  belongs_to :user
  belongs_to :application 

  after_create :register_event
  after_create :segment_track_connection

  validates :email, presence: true 

  scope :connected, -> { where(status: "connected") }
  scope :disconnected, -> { where(status: "disconnected") }

  # def decrypt_credentials
  #   # Use env to get pkey
  # end

  def connected? 
    status == "connected"
  end

  def disconnected? 
    status == "disconnected"
  end

  # Raises an exception if auth is invalid
  def validate_auth!
    if application.config["auth"]["needs_password"]
      response = Api::Observer.client.post("/users/#{user_id}/validate_auth", {
        credentials: {
          application_id: application_id, 
          email: email, 
          encrypted_password: encrypted_password, 
        }
      })

      if !response.success? || response.body[:authorized] != true
        raise ApplicationController::NotAuthorized.new(I18n.t("errors.applications.auth.failure")) 
      end
    end
    true
  end

  def as_json(options={})
    super(options).merge(app_config: application.config)
  end

  private 
  def register_event 
    if user.connected_applications.any? 
      Event.emit(
        type: "application:connected",
        user: user
      )
    else # First application connected
      Event.emit(
        type: "onboarding:application",
        user: user
      )
    end
  end

  def segment_track_connection
    if user.connected_applications.any? 
      Analytics.track({
        user_id: self.user_id,
        event: 'Application Connected',
        properties: { application: self.application.name }
      })
    else # First application connected
      Analytics.track({
        user_id: self.user_id,
        event: 'First Application Connected',
        properties: { application: self.application.name }
      })
    end
  end

end