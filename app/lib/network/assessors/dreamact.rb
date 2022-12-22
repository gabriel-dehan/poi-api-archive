class Network::Assessors::Dreamact < Network::Assessor 

  def compute
    # Data sent for impact measurement
    transactions = data["transactions"]
    
    # TODO: Should probably proc error in cane of empty transaction. Same for all other assessors
    if transactions.any?
      criteria = activable_criteria.find_by(uid: 'dreamact')

      raise CriteriaInactive.new('The criteria `dreamact` has not been activated for the current application.') unless criteria
    
      total_points = 0

      sub_criterium = criteria.sub_criteria.find_by(name: "generic_purchase")
      
      transactions.map do |tx|
        labels_count = tx["impacts"].length
        points = tx["total"] * sub_criterium.data["labels_count_coefficient"] * labels_count
        saved_co2 = tx["total"] * sub_criterium.data["saved_co2_per_label"] * labels_count

        event.activations.new({
          sub_criterium: sub_criterium, 
          impact_points_cents: points * 100.0,
          impact_data: {
            saved_co2: saved_co2
          }
        })

        total_points += points
      end
     
      event.impact_points_cents += (total_points * 100.0)
     
      event
    end
  end
end
