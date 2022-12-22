require 'ostruct'

# A request to be authenticated
class Charon::Passenger::Internal 
  attr_reader :attributes 

  def initialize 
    @attributes = {
      api_public_key: ENV['INTERNAL_API_PUBLIC_KEY'],
      api_private_key: ENV['INTERNAL_API_PRIVATE_KEY']
    }
   
    # Overwrites the key method so when fetching key it encrypts the given value before matching.
    # This is because we only store the Bcrypt encrypted public and private key on this server.
    # This is also because we want to keep the same API as an Active Record object, see Charon::Passenger#authenticate_and_authorize
    @attributes.define_singleton_method(:key) do |value|
      self.invert.select do |api_key, name| 
        BCrypt::Password.new(api_key) == value 
      end.values.first
    end

    @attributes.define_singleton_method(:slice) do |a, b, c, d|
      return self # We don't need to slice, just return the same modified hash
    end

  end
end