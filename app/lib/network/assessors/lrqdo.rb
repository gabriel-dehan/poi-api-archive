class Network::Assessors::Lrqdo < Network::Assessor 

  def compute
    # Data sent for impact measurment
    invoices = data["invoices"]

    if invoices.any?  
      criteria = activable_criteria.find_by(uid: 'lrqdo')

      raise CriteriaInactive.new('The criteria `toogoodtogo` has not been activated for the current application.') unless criteria
    
      total_points = 0

      sub_criterium = criteria.sub_criteria.find_by(name: "generic_purchase")

      invoices.each do |invoice|  
        payed = invoice["payment"]["total"].to_i / 100.0
        coeff = sub_criterium.impact_coefficient
        points = payed * coeff
        
        event.activations.new({
          sub_criterium: sub_criterium, 
          impact_points_cents: points * 100.0,
        })

        total_points += points
      end
     
      event.impact_points_cents += total_points * 100.0
        
      event
    end
  end
end
