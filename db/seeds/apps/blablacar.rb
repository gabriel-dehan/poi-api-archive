module Seeds
  module Apps
    module Blablacar
      def self.create!
        blablacar = Application.create!({
          name: "Blablacar",
          uid: "blablacar",
          category: "mobility",
          tagline: I18n.t("applications.blablacar.tagline"),
          description: I18n.t("applications.blablacar.description"),
          video_url: "https://youtu.be/TjFUY41RgD8",
          web_url: "https://www.blablacar.fr",
          android_url: "https://play.google.com/store/apps/details?id=com.comuto",
          ios_url: "https://itunes.apple.com/fr/app/blablacar-covoiturage/id341329033?mt=8",
          requested_permissions: I18n.t("applications.blablacar.requested_permissions"),
          poi_earn_tagline: I18n.t("applications.blablacar.poi_earn_tagline"),
          rating: 4.5,
          config: {
            csv_export: false,
            auth: {
              needs_password: true,
              reset_password_link: "https://www.blablacar.fr/password-lost",
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

        blablacar.pictures.create!([{
          type: "icon",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_blablacar.jpg",
        }])

        blablacar.pictures.create!([{
          type: "banner",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/banner_blablacar.png",
        }])

        # Setup liblablacarme's criteria
        Criterium.find_by(uid: "transport").sub_criteria.each do |sub_criterium|
          blablacar.sub_criterium_fulfillments.create(sub_criterium: sub_criterium)
        end
      end
    end
  end
end
