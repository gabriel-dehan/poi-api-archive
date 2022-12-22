module Seeds
  module Apps
    module Toogoodtogo
      def self.create!
        toogoodtogo = Application.create!({
          name: "Too Good To Go",
          uid: "toogoodtogo",
          category: "consumption",
          tagline: I18n.t("applications.toogoodtogo.tagline"),
          description: I18n.t("applications.toogoodtogo.description"),
          video_url: "https://www.youtube.com/watch?v=2XMwZWpw1uA",
          web_url: "https://toogoodtogo.fr",
          android_url: "https://play.google.com/store/apps/details?id=com.app.tgtg",
          ios_url: "https://itunes.apple.com/fr/app/too-good-to-go/id1060683933?mt=8",
          requested_permissions: I18n.t("applications.toogoodtogo.requested_permissions"),
          poi_earn_tagline: I18n.t("applications.toogoodtogo.poi_earn_tagline"),
          rating: 4.8,
          config: {
            csv_export: false,
            auth: {
              needs_password: true,
              auth_providers: ["facebook", "google"]
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

        toogoodtogo.pictures.create!([{
          type: "icon",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_tgtg.jpg",
        }])

        toogoodtogo.pictures.create!([{
          type: "banner",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/banner_tgtg.png",
        }])

        # Setup tgtg's criteria
        Criterium.find_by(uid: "toogoodtogo").sub_criteria.each do |sub_criterium|
          toogoodtogo.sub_criterium_fulfillments.create(sub_criterium: sub_criterium)
        end
      end
    end
  end
end