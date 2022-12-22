# Mother class for all Assessors
class Network::Assessor 
  class NotImplemented < StandardError; end
  class CriteriaInactive < StandardError; end
  class ImpactAssessmentError < StandardError; end

  attr_reader :data, :application, :category, :event

  def initialize(event)
    @event = event
    @category = event.category 
    @application = event.application
    @data = event.parameters
  end

  # Should always return the event
  def compute! 
    raise NotImplemented.new()
  end

  def activable_criteria
    if application 
      # Find activated criteria for app
      activable_criteria = application.criteria
    else
      # Find activated criteria for category
      activable_criteria = Criterium.where(category: category)
    end
  end
end