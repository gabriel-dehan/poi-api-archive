class Network::Assessors::Toogoodtogo < Network::Assessor 
  def compute
    # Data sent for impact measurment
    orders = data["orders"]

    if orders.any?  
      criteria = activable_criteria.find_by(uid: 'toogoodtogo')

      raise CriteriaInactive.new('The criteria `toogoodtogo` has not been activated for the current application.') unless criteria
    
      total_points = 0

      orders.each do |order|
        type = "restaurant"

        sub_criterium = criteria.sub_criteria.find_by(name: type)
        raise ImpactAssessmentError.new("This type of merchant: #{type} isn't valid.") unless sub_criterium
  
        cart_type = sub_criterium.data["cart_type"]["default"]
        coeff = (sub_criterium.impact_coefficient + cart_type["coefficient_modifier"]).to_f
        
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