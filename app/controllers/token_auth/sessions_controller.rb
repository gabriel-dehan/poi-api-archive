module TokenAuth
  class SessionsController < DeviseTokenAuth::SessionsController
    def render_create_success
      render 'devise/sessions/create'
    end
  end
end