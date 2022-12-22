require 'bcrypt'

namespace :internal_keys do
  desc "generate internal keys"
  task :generate => :environment do
    public_api_key = "lv_#{SecureRandom.urlsafe_base64(nil, false)}"
    # We don't want them to be the same however unlikely it might be
    private_api_key = loop do
      key = "lv_#{SecureRandom.urlsafe_base64(nil, false)}"
      break key unless key == public_api_key
    end

    encrypted_pbkey = BCrypt::Password.create(public_api_key)
    encrypted_pvkey =  BCrypt::Password.create(private_api_key)
    puts "Public key: [Encrypted] #{encrypted_pbkey} | [Clear] #{public_api_key}"
    puts "Private key: [Encrypted] #{encrypted_pvkey} | [Clear] #{private_api_key}"
  end
end
