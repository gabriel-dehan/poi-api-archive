module Seeds
  module Apps
    def self.cleanup!
      ConnectedApplication.destroy_all unless Rails.env.production?
      Application.destroy_all unless Rails.env.production?
    end

    def self.seed!
      Seeds::Apps::Blablacar.create! 
      Seeds::Apps::Lrqdo.create! 
      Seeds::Apps::Phenix.create! 
      Seeds::Apps::Yoyo.create! 
      Seeds::Apps::Toogoodtogo.create! 
    end
  end
end

# Application.update_all(config: {
#   endpoints: [
#     {
#       name: "main",
#       batched: false,
#       url: "" ,
#       auth: {
#         required: true,
#         type: "bearer"
#       }
#     }
#   ] 
# })