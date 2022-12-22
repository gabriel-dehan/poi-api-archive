require 'ostruct'

# A request to be authenticated
class Charon::Passenger
  attr_reader :env, :handler, :serializer, :service

  AUTHORIZATION_KEYS = ['HTTP_AUTHORIZATION', 'X-HTTP_AUTHORIZATION', 'X_HTTP_AUTHORIZATION']
  ENV_ERRORS = 'charon.errors'.freeze

  def initialize(env, handler)
    @env, @handler = env, handler
    @service = OpenStruct.new # The actual passenger, the service requesting authentication
    @service.auth_request = OpenStruct.new

    # debug_request
  end

  def process 
    # if is logout 
    # clear_session!
    # if is login 
    identify!
    authenticate_and_authorize!
  end

  def identify! 
    scheme, client_id, api_key = decode_authorization_headers
    @service.auth_request.scheme = scheme 
    @service.auth_request.client_id = client_id 
    @service.auth_request.api_key = api_key 
    @service.in_sandbox = !!api_key.match(/^sb.*/) # if api key starts with sb we are in sandbox mode
   
    # look if client id is internal
    if Charon::INTERNAL_CLIENTS.include? client_id 
      @service.type = :internal
      @service.app_id = nil
      @service.data = Internal.new
    else # if not look for application with matching client_id 
      app = Application.find_by(api_client_id: client_id)
      if app 
        @service.type = :external
        @service.app_id = app.id
        @service.data = app
      else
        throw(:charon) # throw error and handle error somewhere down the stack
      end
    end
  end 

  def authenticate_and_authorize!
    # We look in the application's attributes for any key that matches the given one
    api_key_type = @service.data.attributes.slice("api_public_key", "api_private_key", "sandbox_public_key", "sandbox_private_key").key(@service.auth_request.api_key)
    # If no corresponding attribute was found it means the API Key is incorrect and we need to send an error 

    throw(:charon_type) unless api_key_type

    # A private key has access to the same things as a public + more, thus if the API key was correct public access are automaticaly granted
    @service.has_public_access = true
    @service.has_private_access = !!api_key_type.match(/private/)

     # if already authenticated do nothing
    if session && (session["has_public_access"] || session["session.has_private_access"])
      true 
    else # if in need of authentication  
      # We don't want to remove 'data' from the service object but we don't want it in the session
      service_serialized = @service.clone
      service_serialized.delete_field(:data)
      # We don't want to store an open struct
      service_serialized.auth_request = service_serialized.auth_request.to_h 

      session_store(service_serialized.to_h)
      true
    end
  end

  def request
    @request ||= Rack::Request.new(@env)
  end

  def headers 
    @headers ||= Hash[*env.select {|k,v| k.start_with? 'HTTP_'}
      .collect {|k,v| [k.sub(/^HTTP_/, ''), v]}
      .collect {|k,v| [k.split('_').collect(&:capitalize).join('-'), v]}
      .sort
    .flatten]
  end

  def params
    request.params
  end

  def session
    env['rack.session']
  end

  def session_store(value)
    env['rack.session']['charon.passenger'] = value
  end

  def clear_session!
    session.delete('charon.passenger')
  end

  def errors
    @env[ENV_ERRORS] ||= Errors.new
  end

  private

  def decode_authorization_headers
    auth_header = env[authorization_key]
    throw(:charon) unless auth_header
    scheme, credentials = auth_header.split(' ', 2)
    scheme = scheme.downcase.to_sym
    client_id, api_key = credentials.unpack("m*").first.split(/:/, 2)

    [scheme, client_id, api_key]
  end

  def authorization_key
    @authorization_key ||= AUTHORIZATION_KEYS.detect { |key| @env.has_key?(key) }
  end

  def debug_request
    puts "= HEADERS ="
    pp headers 
    puts "= BODY ="
    pp request.body
    puts "= XHR? ="
    pp request.xhr? 
    puts "= QUERY ="
    pp request.query_string
  end
end