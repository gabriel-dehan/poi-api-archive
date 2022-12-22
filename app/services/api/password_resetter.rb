module Api
  # Class used to trigger automatized password reset for our partner applications,
  # in case users forget their password, they could reset it through our app without having to log in into the partner app.
  class PasswordResetter
    def initialize(email, app)
      @email = email
      @app = app
    end

    def client(url, &block)
      connection = Faraday.new(url) do |connection|
        connection.use :instrumentation

        connection.request :json

        connection.response :logger
        connection.response :json, :content_type => /\bjson$/

        connection.adapter Faraday.default_adapter

         # Setup headers and other things
         block.call(connection) if block_given?
      end

      Base::Client.new(connection)
    end

    def reset!
      self.send(@app.uid)
    end
    # The name of the method must be the application `uid`

    def blablacar
      # client("https://xyz.com/").post('cyz')
    end

    def phenix
      client("http://xyz/")
      .post('cyz', { username: @email })
    end

    def lrqdo
      client("http://xyz")
      .post('cyz/', { email: @email })
    end

    def goodeed
      client("http://xyz")
      .post("", {
        "#{SecureRandom.uuid}" => {
          action: "cyz",
          module: "cyz",
          email: @email
        }
      })
    end

    def toogoodtogo
      client("http://xyz") do |connection|
        connection.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      end.post('cyz', { email: @email, localtime: Time.now.to_s })
    end

    def lilo
      client("http://xyz") do |connection|
        connection.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      end.post("cyz", { email: @email, action: "actionRequestNewPass" })
    end

    def dreamact
      client("http://xyz") do |connection|
        connection.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      end.post("cyz", { email: @email })
    end
  end
end