module Network 
  class Impact
    def self.assess(event)
      if event.application
        assessor_name = "Network::Assessors::#{event.application.uid.classify}"    
      elsif event.category == "bonus"
        # Rails "bonus".classify returns Bonus so we make an exception
        assessor_name = "Network::Assessors::Bonus"
      else 
        # Network::Assessors::Mobility for instance
        assessor_name = "Network::Assessors::#{event.category.classify}"
      end
      
      assessor = assessor_name.constantize.new(event)
      assessor.compute
    end
  end
end