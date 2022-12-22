class User::ParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(:sign_up, keys: [:full_name, :phone_number, :referrer_code])
    permit(:account_update, keys: [:full_name, :phone_number])
  end
end