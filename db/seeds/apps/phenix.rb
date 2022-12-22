module Seeds
  module Apps
    module Phenix
      def self.create!
        phenix = Application.create!({
          name: "Phenix",
          uid: "phenix",
          category: "consumption",
          tagline: I18n.t("applications.phenix.tagline"),
          description: I18n.t("applications.phenix.description"),
          video_url: "https://www.youtube.com/watch?v=VTjM_tZJF94",
          web_url: "https://antigaspi.wearephenix.com",
          android_url: "https://play.google.com/store/apps/details?id=com.phenix.cajou",
          ios_url: "https://itunes.apple.com/fr/app/phenix-vos-courses-antigaspi/id1437997699",
          requested_permissions: I18n.t("applications.phenix.requested_permissions"),
          poi_earn_tagline: I18n.t("applications.phenix.poi_earn_tagline"),
          rating: 4.2,
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
                  type: "x-wsse"
                }
              }
            ]
          }
        })

        phenix.pictures.create!([{
          type: "icon",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_phenix.png",
        }])

        phenix.pictures.create!([{
          type: "banner",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/banner_phenix.png",
        }])

        # Setup lime's criteria
        Criterium.find_by(uid: "phenix").sub_criteria.each do |sub_criterium|
          phenix.sub_criterium_fulfillments.create(sub_criterium: sub_criterium)
        end
      end
    end
  end
end