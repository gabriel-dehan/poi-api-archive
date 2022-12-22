class Network::Assessors::Lilo < Network::Assessor 

  def compute
    # Data sent for impact measurement
    drops = data["total_drops"]
    p drops
    if drops > 0
      criteria = activable_criteria.find_by(uid: 'lilo')

      raise CriteriaInactive.new('The criteria `lilo` has not been activated for the current application.') unless criteria
    
      sub_criterium = criteria.sub_criteria.find_by(name: "search")
      money_coeff = sub_criterium.data["donated_money_coeff"]
      coeff = sub_criterium.impact_coefficient
      
      donated_money = drops * money_coeff
      points = drops * coeff
        
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
