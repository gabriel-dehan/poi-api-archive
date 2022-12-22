module Seeds
  module PotentialApps
    def self.cleanup!
      PotentialApplication.destroy_all unless Rails.env.production?
    end

    def self.seed!
      # PotentialApplication.find_by(name: "Cityscoot")&.destroy
      # cityscoot = PotentialApplication.create!(
      #   {
      #     name: "Cityscoot",
      #     category: "mobility",
      #     description: "La plus belle façon de se déplacer en ville. Des milliers de scooters électriques en libre-service à Paris, Nice et Milan !",
      #     url: "https://www.cityscoot.eu",
      #     status: "reviewing"
      #   }
      # )

      # cityscoot.pictures.create!([{
      #   type: "icon",
      #   remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_cityscoot.png",
      # }])

      # PotentialApplication.find_by(name: "Fitbit")&.destroy
      # fitbit = PotentialApplication.create!(
      #   {
      #     name: "Fitbit",
      #     category: "mobility",
      #     description: "",
      #     url: "https://fitbit.com",
      #     status: "reviewing"
      #   }
      # )

      # fitbit.pictures.create!([{
      #   type: "icon",
      #   remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_fitbit.jpg",
      # }])

      # PotentialApplication.find_by(name: "Lilo")&.destroy
      # lilo = PotentialApplication.create!(
      #   {
      #     name: "Lilo",
      #     category: "S",
      #     description: "",
      #     url: "https://www.lilo.org",
      #     status: "reviewing"
      #   }
      # )

      # lilo.pictures.create!([{
      #   type: "icon",
      #   remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_lilo.jpg",
      # }])

      PotentialApplication.find_by(name: "Felix")&.destroy
      felix = PotentialApplication.create!(
        {
          name: "Felix",
          category: "mobility",
          description: "",
          url: "https://www.felix-app.com",
          status: "reviewing"
        }
      )

      felix.pictures.create!([{
        type: "icon",
        remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_felix.jpg",
      }])

      PotentialApplication.find_by(name: "Indigo")&.destroy
      indigo = PotentialApplication.create!(
        {
          name: "Indigo",
          category: "citizenship",
          description: "",
          url: "https://indigo.world",
          status: "reviewing"
        }
      )

      indigo.pictures.create!([{
        type: "icon",
        remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_indigo.jpg",
      }])

      PotentialApplication.find_by(name: "Smiile")&.destroy
      smiile = PotentialApplication.create!(
        {
          name: "Smiile",
          category: "citizenship",
          description: "",
          url: "https://smiile.world",
          status: "reviewing"
        }
      )

      smiile.pictures.create!([{
        type: "icon",
        remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_smiile.jpg",
      }])

      PotentialApplication.find_by(name: "Karos")&.destroy
      karos = PotentialApplication.create!(
        {
          name: "Karos",
          category: "mobility",
          description: "",
          url: "https://www.karos.fr",
          status: "reviewing"
        }
      )

      karos.pictures.create!([{
        type: "icon",
        remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_karos.jpg",
      }])

      PotentialApplication.find_by(name: "Entourage")&.destroy
      entourage = PotentialApplication.create!(
        {
          name: "Entourage",
          category: "citizenship",
          description: "",
          url: "https://www.entourage.social",
          status: "reviewing"
        }
      )

      entourage.pictures.create!([{
        type: "icon",
        remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_entourage.jpg",
      }])

      PotentialApplication.find_by(name: "Back Market")&.destroy
      backmarket = PotentialApplication.create!(
        {
          name: "Back Market",
          category: "consumption",
          description: "",
          url: "https://www.backmarket.fr",
          status: "reviewing"
        }
      )

      backmarket.pictures.create!([{
        type: "icon",
        remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_backmarket.jpg",
      }])

      PotentialApplication.find_by(name: "GEEV")&.destroy
      geev = PotentialApplication.create!(
        {
          name: "GEEV",
          category: "citizenship",
          description: "",
          url: "https://www.geev.fr",
          status: "reviewing"
        }
      )

      geev.pictures.create!([{
        type: "icon",
        remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_geev.jpg",
      }])


      PotentialApplication.find_by(name: "Oribiky")&.destroy
      oribiky = PotentialApplication.create!(
        {
          name: "Oribiky",
          category: "mobility",
          description: "",
          url: "https://www.oribiky.com",
          status: "reviewing"
        }
      )

      oribiky.pictures.create!([{
        type: "icon",
        remote_file_url: "https://s3.somewhere.over/the-rainbow/seeds/logo_oribiky.jpg",
      }])

    end
  end
end