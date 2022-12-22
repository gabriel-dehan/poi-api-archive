module Seeds
  module Apps
    module Goodeed
      def self.create!
        goodeed = Application.create!({
          name: "Goodeed",
          uid: "goodeed",
          category: "citizenship",
          tagline: I18n.t("applications.goodeed.tagline"),
          description: I18n.t("applications.goodeed.description"),
          video_url: "https://youtu.be/D1FWBmynHSc",
          web_url: "https://www.goodeed.com",
          android_url: "https://play.google.com/store/apps/details?id=com.goodeed.app",
          ios_url: "https://itunes.apple.com/fr/app/goodeed/id1160336950",
          requested_permissions: I18n.t("applications.goodeed.requested_permissions"),
          poi_earn_tagline: I18n.t("applications.goodeed.poi_earn_tagline"),
          rating: 4.9,
          config: {
            csv_export: false,
            auth: {
              needs_password: true,
              auth_providers: ["facebook", "twitter"]
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

        goodeed.pictures.create!([{
          type: "icon",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_goodeed.jpg",
        }])

        goodeed.pictures.create!([{
          type: "banner",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/banner_goodeed.png",
        }])

        # Setup goodeed's criteria
        Criterium.find_by(uid: "goodeed").sub_criteria.each do |sub_criterium|
          goodeed.sub_criterium_fulfillments.create(sub_criterium: sub_criterium)
        end
      end
    end
  end
end
