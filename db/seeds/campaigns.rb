module Seeds
  module Campaigns
    def self.cleanup!
      Campaign.destroy_all unless Rails.env.production?
    end

    def self.seed_relations!
      User.all.each do |user|
        user.fundings.create({
          campaign: Campaign.all.sample,
          amount_cents: 1000
        })
      end
    end

    def self.seed!
      Campaign.create!([
        {
          name: "Nouveau potager communal",
          tagline: "Aidez la communauté !",
          description: "Lorem ipsum dolor es sit amet",
          success_label: "Le nouveau potager vous remercie !"
        },
        {
          name: "Nouveau potager communal",
          tagline: "Aidez la communauté !",
          description: "Lorem ipsum dolor es sit amet",
          success_label: "Le nouveau potager vous remercie !"
        }
      ])
    end
  end
end