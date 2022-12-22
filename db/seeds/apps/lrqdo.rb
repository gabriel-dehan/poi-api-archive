module Seeds
  module Apps
    module Lrqdo
      def self.create!
        lrqdo = Application.create!({
          name: "La Ruche Qui Dit Oui",
          uid: "lrqdo",
          category: "consumption",
          tagline: I18n.t("applications.lrqdo.tagline"),
          description: I18n.t("applications.lrqdo.description"),
          video_url: "https://youtu.be/grElHRiYgRE",
          web_url: "https://laruchequiditoui.fr",
          android_url: "https://play.google.com/store/apps/details?id=com.lrqdo&hl=fr",
          ios_url: "https://itunes.apple.com/fr/app/la-ruche-qui-dit-oui/id1052198033?mt=8",
          requested_permissions: I18n.t("applications.lrqdo.requested_permissions"),
          poi_earn_tagline: I18n.t("applications.lrqdo.poi_earn_tagline"),
          rating: 4.2,
          config: {
            csv_export: false,
            auth: {
              needs_password: true,
              auth_providers: []
            },
            endpoints: [
              {
                name: "main",
                batched: false,
                url: "",
                auth: {
                  required: true,
                  type: "bearer"
                }
              }
            ]
          }
        })

        lrqdo.pictures.create!([{
          type: "icon",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_lrqdo.jpg",
        }])

        lrqdo.pictures.create!([{
          type: "banner",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/banner_lrqdo.jpg",
        }])

        # Setup lime's criteria
        Criterium.find_by(uid: "lrqdo").sub_criteria.each do |sub_criterium|
          lrqdo.sub_criterium_fulfillments.create(sub_criterium: sub_criterium)
        end
      end
    end
  end
end