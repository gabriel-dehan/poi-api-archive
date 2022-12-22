class AssignedTask < ApplicationRecord
  belongs_to :user
  belongs_to :task_blueprint
  alias_attribute :task, :task_blueprint # convenient 

  delegate :name, to: :task_blueprint, allow_nil: true
  delegate :description, to: :task_blueprint, allow_nil: true
  delegate :hidden, to: :task_blueprint, allow_nil: true
  delegate :timespan, to: :task_blueprint, allow_nil: true
  delegate :reward, to: :task_blueprint, allow_nil: true
  delegate :reward_cents, to: :task_blueprint, allow_nil: true
  delegate :maximum_occurence, to: :task_blueprint, allow_nil: true
  scope :displayable, ->{ joins(:task_blueprint).where('task_blueprints.hidden = ?', false) }

  def events
    Event.where("parameters ->> 'assigned_task_id' = '?'", self.id)
  end

  def action_taken!
    if !done?
      self.completion_count += 1 
      self.completed = true if self.completion_count == maximum_occurence
      self.save!

      # Emit an event and trigger a reward
      if self.task.should_trigger_event?
        self.emit_completion_event(user)
      end
    end
  end

  def emit_completion_event(user)
    Event.emit({
      user: user,
      type: 'task',
      category: 'bonus',
      data: {
        task: self.task.class.to_s, # used for display
        assigned_task_id: self.id, # very important for later queries
        reward_cents: reward_cents # used for reward computation
      }
    })
  end

  def done? 
    completed == true
  end

  # If the user has at least started the task 
  def started?
    completion_count > 0
  end

  def has_timespan?
    timespan 
  end

  def remaining_time
    if has_timespan? 
      (self.created_at + timespan).to_i - DateTime.now.to_i
    else 
      nil 
    end
  end

  # Gives the remaining time either in days, hours, minutes or seconds
  def sensible_remaining_time
    if has_timespan?
      if remaining_time >= ActiveSupport::Duration::SECONDS_PER_DAY
        { day: remaining_time / ActiveSupport::Duration::SECONDS_PER_DAY }
      elsif remaining_time >= ActiveSupport::Duration::SECONDS_PER_HOUR
        { hour: remaining_time / ActiveSupport::Duration::SECONDS_PER_HOUR } 
      elsif remaining_time >= ActiveSupport::Duration::SECONDS_PER_MINUTE
        { minute: remaining_time / ActiveSupport::Duration::SECONDS_PER_MINUTE }
      elsif remaining_time > 0
        { second: remaining_time }
      else
        { second: 0 }
      end
    end
  end

  def formatted_remaining_time
    rt = sensible_remaining_time
    unit = rt.keys.first 
    time = rt.values.first
    I18n.t('tasks.timespans', unit: I18n.t("datetime.prompts.#{unit}").downcase, count: time)
  end

  def has_time_remaining?
    if has_timespan?
      remaining_time > 0
    else
      true
    end
  end
end