
module Seeds
  module Apps
    module Yoyo
      def self.create!
        yoyo = Application.create!({
          name: "Yoyo",
          uid: "yoyo",
          category: "recycling",
          tagline: I18n.t("applications.yoyo.tagline"),
          description: I18n.t("applications.yoyo.description"),
          video_url: nil,
          web_url: "https://yoyo.eco",
          android_url: "https://yoyo.eco",
          ios_url: "https://yoyo.eco",
          requested_permissions: I18n.t("applications.yoyo.requested_permissions"),
          poi_earn_tagline: I18n.t("applications.yoyo.poi_earn_tagline"),
          rating: nil,
          config: {
            csv_export: false,
            auth: {
              needs_password: false,
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

        yoyo.pictures.create!([{
          type: "icon",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_yoyo.png",
        }])

        yoyo.pictures.create!([{
          type: "banner",
          remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/banner_yoyo.png",
        }])

      end
    end
  end
end