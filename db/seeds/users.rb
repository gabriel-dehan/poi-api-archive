module Seeds
  module Users
    def self.cleanup!
      User.destroy_all unless Rails.env.production?
    end

    def self.seed!
      User.create!([
        {
          email: "gabriel@poi.app",
          password: "password",
          password_confirmation: "password",
          full_name: "Gaby Dehan",
          phone_number: "0683853939"
        },
        {
          email: "jeremy@poi.app",
          password: "password",
          password_confirmation: "password",
          full_name: "Jeremy Andre",
          phone_number: "0683853938"
        }
      ])
    end
  end
end