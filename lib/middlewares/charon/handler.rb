# Charon, the ferryman of Hades who carries souls of the newly deceased across the rivers Styx.
# He will do the same for our requests signed by services tokens.
class Charon::Handler 
    def initialize(app)
      @app = app
    end

    def call(env) # :nodoc:
      #unless ActionDispatch::Request.new(env).fullpath.match(/^\/forest|^\/sidekiq/)
      if ActionDispatch::Request.new(env).fullpath.match(/^\/v1|^\/v2|^\/v3/)
        env['charon.passenger'] = Charon::Passenger.new(env, self).process
      end
      @status, @headers, @response =  @app.call(env)

      #result = catch(:warden) do
      #  env['warden'].on_request
      #end

      [@status, @headers, @response]
    end
end