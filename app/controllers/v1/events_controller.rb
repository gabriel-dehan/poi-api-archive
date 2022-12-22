class V1::EventsController < ApplicationController
  access_level :public, only: [:emit]
  access_level :private, only: [:batch_emit]

  internal_only false, only: [:emit, :batch_emit]

  skip_before_action :authenticate_user!, only: [:emit, :batch_emit], if: :has_private_access?

  def emit 
    type, category, data = require_params!(:type, :category, :data)
    check_param!(:type) { |type| Event::defined?(type) }
    check_param!(:category) { |category| Application::Categories.include?(category) }
    
    application = Application.find_by(id: params[:application_id]) || current_application
    user = current_user || User.find(params[:user_id])
    
    Event.emit({
      user: user,
      type: type,
      application_id: application&.id,
      category: category,
      data: data
    })
  end

  def batch_emit 
    category, data, application_id = require_params!(:category, :data, :application_id)
    check_param!(:category) { |category| Application::Categories.include?(category) }
    
    application = Application.find_by(id: application_id)

    data.each do |impact_data| 
      Event.emit({
        user_id: impact_data[:user_id],
        type: 'action',
        application_id: application.id,
        category: category,
        data: impact_data[:data]
      })
    end
  end

end
