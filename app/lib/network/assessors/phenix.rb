class Network::Assessors::Phenix < Network::Assessor 
  ADVERTISER_TYPES = {
    'Supermarché' => "supermarket",
    'Epicerie' => "local_shop",
    'Artisan' => "artisan_shop",
	  'Fleuriste' => "florist",
	  'Hôtel' => "hotel",
	  'Boulangerie' => "bakery",
	  'Restaurant' => "restaurant",
	  'Traiteur' => "caterer",
	  'Foodtech' => "foodtech",
	  'Primeur' => "greengrocer",
	  'Salon de thé' => "tea_house"
  }

  def compute
    # Data sent for impact measurment
    orders = data["orders"]

    if orders.any?  
      criteria = activable_criteria.find_by(uid: 'phenix')

      raise CriteriaInactive.new('The criteria `phenix` has not been activated for the current application.') unless criteria
    
      total_points = 0

      orders.each do |order|
        price = order["totalInclTax"]
        type = ADVERTISER_TYPES[order["advertiser"]["type"]["name"]]

        sub_criterium = criteria.sub_criteria.find_by(name: type)
        raise ImpactAssessmentError.new("This type of merchant: #{type} isn't valid.") unless sub_criterium
  
        # TODO: Handle different cart types
        cart_type = sub_criterium.data["cart_type"]["default"]
        coeff = (sub_criterium.impact_coefficient + cart_type["coefficient_modifier"]).to_f
        
        # TODO: Handle quantities
        saved_co2 = cart_type["saved_co2"]
        points = saved_co2 * coeff
        
        event.activations.new({
          sub_criterium: sub_criterium, 
          impact_points_cents: points * 100.0,
          impact_data: {
            saved_co2: saved_co2
          }
        })

        total_points += points
      end
     
      event.impact_points_cents += total_points * 100.0
        
      event
    end
  end
end