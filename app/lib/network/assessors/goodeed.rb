class Network::Assessors::Goodeed < Network::Assessor 

  def compute
    # Data sent for impact measurement
    donations = data["total_donations"]

    if donations > 0
      criteria = activable_criteria.find_by(uid: 'goodeed')

      raise CriteriaInactive.new('The criteria `goodeed` has not been activated for the current application.') unless criteria
    
      sub_criterium = criteria.sub_criteria.find_by(name: "donation")

      money_coeff = sub_criterium.data["donated_money_coeff"]
      coeff = sub_criterium.impact_coefficient
      
      donated_money = donations * money_coeff
      points = donations * coeff
        
      event.activations.new({
        sub_criterium: sub_criterium, 
        impact_points_cents: points * 100.0,
        impact_data: {
          donated_money: donated_money
        }
      })
     
      event.impact_points_cents += (points * 100.0)
        
      event
    end
  end
end
