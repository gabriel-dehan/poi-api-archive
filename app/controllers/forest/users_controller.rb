class Forest::UsersController < ForestLiana::ApplicationController
  #
  def create_event
    user_id = params.dig('data', 'attributes', 'ids').first
    distance = params.dig('data', 'attributes', 'values', 'distance')
    app = params.dig('data', 'attributes', 'values', 'application')
    mean = params.dig('data', 'attributes', 'values', 'transport')

    application = Application.find_by(name: app)

    event = Event.emit({
      user: User.find(user_id),
      type: 'action',
      application_id: application.id,
      category: 'mobility',
      data: {
        distance: distance.to_f,
        transport: mean
      }
    })

    render json: { success: "A new ride has been created! Added #{event.earned_points} POI to your balance !" }
  end

  def emit_static_event 
    user_id = params.dig('data', 'attributes', 'ids').first
    type = params.dig('data', 'attributes', 'values', 'type')

    Event.emit({ 
      user: User.find(user_id), 
      type: type
    })
  end
end