module TokenAuth
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    def render_create_success
      render 'devise/registrations/create'
    end
  end
end