module Seeds
  module Perks
    def self.cleanup!
      Perk.destroy_all unless Rails.env.production?
    end

    def self.seed_relations!
      User.all.each do |user|
        user.earned_perks.create({
          perk: Perk.all.sample 
        })
      end
    end

    def self.seed!
      Perk.create!([
        {
          name: "Too Good To Go - 30%",
          tagline: "Consommez positif !",
          success_label: "Profitez en bien !",
          description: "Get - 30% on your next too good to go purchase!",
          price_cents: 400,
          amount: 30.0,
          is_percentage: true,
          application_id: Application.all.pluck(:id).sample
        },
        {
          name: "Cityscoot - 20%",
          tagline: "Consommez positif !",
          success_label: "Profitez en bien !",
          description: "Get - 20% on your next cityscoot thingy!",
          price_cents: 400,
          amount: 30.0,
          is_percentage: true,
          application_id: Application.all.pluck(:id).sample
        }
      ])
    end
  end
end