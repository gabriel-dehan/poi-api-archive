# TODO: Refacto using base.rb
module Api
  class Observer 
    attr_reader :connection

    def self.client
      @client ||= self.new()
    end

    def initialize
      @connection = Faraday.new(url: Rails.env.development? ? "http://localhost:3001" : ENV["OBSERVER_URL"]) do |connection|
        connection.use :instrumentation
        
        connection.request :json
        # connection.basic_auth('poi-observer', ENV['INTERNAL_API_PRIVATE_KEY'])
  
        connection.response :logger
        connection.response :json, :content_type => /\bjson$/
  
        connection.adapter Faraday.default_adapter
      end    
    end

    def get(url, options = nil, &block)
      Api::Response.new(@connection.get(url, options, block))
    end

    def post(url, options = nil, &block)
      Api::Response.new(@connection.post(url, options, block))
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
      p @faraday.body if Rails.env.development?
      if @faraday.body.kind_of? Hash
        @faraday.body.with_indifferent_access
      else  
        @faraday.body 
      end
    end
    alias_method :data, :body
  end
end