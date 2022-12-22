require 'twilio-ruby'

# set up a client to talk to the Twilio REST API
TwilioClient = Twilio::REST::Client.new ENV['TWILIO_API_KEY'], ENV['TWILIO_API_TOKEN']

# TODO: Move to a service 
TwilioSMSHandler = ->(number, message) {
  begin 
    TwilioClient.api.account.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: number,
      body: message
    )
  rescue Exception => e
    puts e
  end
}
