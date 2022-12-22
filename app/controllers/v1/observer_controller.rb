class V1::ObserverController < ApplicationController
  access_level :public

  def refresh_user_impact 
    # Make a call to the observer
    Api::Observer.client.post("/users/#{current_user.id}/refresh")

    render json: { success: true }
  end
end