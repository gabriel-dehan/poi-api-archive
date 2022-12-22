module Seeds
  module Apps
    module Dreamact
      def self.create!
        dreamact = Application.create!({
          name: "Dreamact",
          uid: "dreamact",
          category: "consumption",
          tagline: I18n.t("applications.dreamact.tagline"),
          description: I18n.t("applications.dreamact.description"),
          video_url: "",
          web_url: "https://dreamact.eu",
          android_url: "https://dreamact.eu",
          ios_url: "https://dreamact.eu",
          requested_permissions: I18n.t("applications.dreamact.requested_permissions"),
          poi_earn_tagline: I18n.t("applications.dreamact.poi_earn_tagline"),
          rating: 4.9,
          config: {
            csv_export: false,
            auth: {
              needs_password: false,
              reset_password_link: "https://dreamact.eu/fr/forgot-password",
              auth_providers: ["facebook"]
            },
            endpoints: [
              {
                name: "main",
                auth: {
                  required: true,
                  type: "bearer"
                }
              }
            ]
          }
        })

        dreamact.pictures.create!([{
          type: "icon",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_dreamact.png",
        }])

        dreamact.pictures.create!([{
          type: "banner",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/banner_dreamact.jpg",
        }])

        # Setup dreamact's criteria
        Criterium.find_by(uid: "dreamact").sub_criteria.each do |sub_criterium|
          dreamact.sub_criterium_fulfillments.create(sub_criterium: sub_criterium)
        end
      end
    end
  end
end
