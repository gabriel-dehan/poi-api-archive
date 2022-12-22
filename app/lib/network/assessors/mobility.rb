class Network::Assessors::Mobility < Network::Assessor 

  def compute
    # activable_criteria

    # Data sent for impact measurment
    mean = data["transport"]
    distance = data["distance"] # in km

    if mean && distance    
      # Find criteria for computing 
      criteria = activable_criteria.find_by(uid: 'transport')
      raise CriteriaInactive.new('The criteria `transport` has not been activated for the current application.') unless criteria
    
      # distance km but we want meters
      distance = distance * 1000 

      sub_criterium = criteria.sub_criteria.find_by(name: mean)
      raise ImpactAssessmentError.new("This mean of transport: #{mean} isn't valid.") unless sub_criterium

      min_distance, max_distance = sub_criterium.data["distance"]["thresholds"]

      if distance >= min_distance 
        number_of_activations = distance / min_distance 
        points = (sub_criterium.impact_coefficient * number_of_activations).to_i

        event.activations.new({
          sub_criterium: sub_criterium, 
          impact_points_cents: points * 100.0,
          impact_data: {
            saved_co2: number_of_activations * sub_criterium.data["saved_co2"]["value"] # TODO: Check if it works
          }
        })
        event.impact_points_cents += points * 100.0
      end

      event
    end
  end
end