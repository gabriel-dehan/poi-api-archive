class Network::Assessors::Bonus < Network::Assessor 
  
  def compute
    # Handle tasks, challenges and static impacts 
    if event.type == 'challenge'
      challenge = FriendsChallenge.find(event.parameters["friend_challenge_id"])
      event.impact_points_cents += challenge.reward_cents 
    elsif event.type == 'task'
      event.impact_points_cents += event.parameters["reward_cents"].to_i
    else # Other static events
      event.impact_points_cents += Event::StaticImpacts[event.type] * 100.0
    end
    event 
  end
end
