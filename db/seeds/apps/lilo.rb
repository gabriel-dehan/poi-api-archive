module Seeds
  module Apps
    module Lilo
      def self.create!
        lilo = Application.create!({
          name: "Lilo",
          uid: "lilo",
          category: "citizenship",
          tagline: I18n.t("applications.lilo.tagline"),
          description: I18n.t("applications.lilo.description"),
          video_url: "https://www.youtube.com/watch?v=W3-I2VSHxxg",
          web_url: "https://www.lilo.org",
          android_url: "https://play.google.com/store/apps/details?id=org.lilo.browser",
          ios_url: "https://itunes.apple.com/fr/app/lilo-browser/id1339709376",
          requested_permissions: I18n.t("applications.lilo.requested_permissions"),
          poi_earn_tagline: I18n.t("applications.lilo.poi_earn_tagline"),
          rating: 4.9,
          config: {
            csv_export: false,
            auth: {
              needs_password: true,
              auth_providers: []
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

        lilo.pictures.create!([{
          type: "icon",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_lilo.jpg",
        }])

        lilo.pictures.create!([{
          type: "banner",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/banner_lilo.png",
        }])

        # Setup lilo's criteria
        Criterium.find_by(uid: "lilo").sub_criteria.each do |sub_criterium|
          lilo.sub_criterium_fulfillments.create(sub_criterium: sub_criterium)
        end
      end
    end
  end
end
