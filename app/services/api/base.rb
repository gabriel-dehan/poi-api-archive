module Api::Base
  class Client 
    attr_reader :connection
    def initialize(connection)
      @connection = connection
    end

    def get(url, data = nil, &block)
      Api::Base::Response.new(@connection.get(url, data, block))
    end

    def post(url, data = nil, &block)

      if @connection.headers["Content-Type"] == 'application/x-www-form-urlencoded'
        data = URI.encode_www_form(data)
      end
      Api::Base::Response.new(@connection.post(url, data, block))
    end
  end 

  class Response 
    attr_reader :faraday 

    delegate :status, to: :faraday
    delegate :headers, to: :faraday

    def initialize(response)
      @faraday = response 
    end

    def success? 
      [200, 201, 202, 203, 204, 205, 206, 207, 226].include? status
    end

    def body 
      if Rails.env.development?
        p @faraday.body
      end
      if @faraday.body.kind_of? Hash
        @faraday.body.with_indifferent_access
      else  
        @faraday.body 
      end
    end
    alias_method :data, :body
  end
end