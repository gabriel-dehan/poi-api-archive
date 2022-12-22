class TaskBlueprint < ApplicationRecord
  has_many :assigned_tasks, dependent: :destroy
  has_many :users, through: :assigned_tasks

  def reward 
    reward_cents / 100.0
  end

  def should_trigger_event?
    false
  end

  def formatted_name
    I18n.t(name)
  end

  def formatted_description
    I18n.t(description)
  end

  # Kind of a singleton 
  def self.get 
    self.first
  end
  
  def assign(user = nil)
    raise GenerationError.new("User missing") unless user 
    
    user.assigned_tasks.create({
      task_blueprint: self
    })
  end

  def timespan_in_days
    timespan / ActiveSupport::Duration::SECONDS_PER_DAY
  end  
end
