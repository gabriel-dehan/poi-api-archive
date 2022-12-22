class GaugeCycle < ApplicationRecord
  INCREASE_PER_LEVEL = 10 # post 25 

  belongs_to :impactable, polymorphic: true

  before_create :compute_maximum_points

  # Main method for adding points to the gauge
  def register_event(event)
    entity = event.user

    gauge_cycle = self.impactable.current_cycle
    # If we have more points remaining than the gauge capacity
    if gauge_cycle.earned_points_cents + event.earned_points_cents >= gauge_cycle.maximum_points_cents
      total_remaining = event.earned_points_cents
      while total_remaining > 0
        # Refetches the cycle because it might switch to a new gauge during the loop
        gauge_cycle = self.impactable.current_cycle

        # If we have more points remaining than the gauge capacity
        if gauge_cycle.earned_points_cents + total_remaining >= gauge_cycle.maximum_points_cents
          # Maximum number of points until gauge is full
          remaining_this_cycle = gauge_cycle.maximum_points_cents - gauge_cycle.earned_points_cents 
        else
          remaining_this_cycle = total_remaining
        end

        gauge_cycle.earned_points_cents += remaining_this_cycle
        gauge_cycle.events_ids << event.id
        gauge_cycle.save! # TODO BUG

        # Create a new cycle and ends this one if the gauge is full
        gauge_cycle.end_cycle! if gauge_cycle.complete?
        
        total_remaining -= remaining_this_cycle
        #binding.pry
      end
    else
      gauge_cycle.earned_points_cents += event.earned_points_cents
      gauge_cycle.events_ids << event.id
      gauge_cycle.save!
    end

    # Update the user's earned points
    self.impactable.update(earned_points_cents: self.impactable.earned_points_cents + event.earned_points_cents)
  end

  def earned_points 
    earned_points_cents / 100.0
  end

  def events
    Event.where(id: events_ids).order(datetime: :desc)
  end

  def last_event
    events.last
  end

  def last_events(num)
    events.limit(num)
  end

  def previous_cycle 
    self.impact.gauge_cycles.order(created_at: :desc)[1] 
  end

  def maximum_points
    maximum_points_cents / 100.0
  end

  def complete?
    self.earned_points_cents >= maximum_points_cents
  end

  def end_cycle!
    # New cycle tho
    new_cycle = self.impactable.gauge_cycles.create!
    # My watch has ended
    self.update!(current: false)
    # Level up! 
    self.impactable.level_up! 
    
    if impactable.level > 1
      new_cycle.update(can_challenge: true) unless impactable['category'] == "bonus"
    end
  end

  private 
  # def compute_maximum_points 
  #   current_cycle = impactable.current_cycle
  #   if current_cycle
  #     self.maximum_points_cents = current_cycle.maximum_points_cents + (INCREASE_PER_LEVEL * current_cycle.maximum_points_cents / 100)

  #   # No current cycle means no previous cycle so we initialize with the default maximum
  #   else
  #     self.maximum_points_cents = DEFAULT_GAUGE_MAX * 100
  #   end
  # end

  def compute_maximum_points 
    current_cycle = impactable.current_cycle
    next_level = impactable.level + 1

    if current_cycle
      if next_level > 25 
        self.maximum_points_cents = current_cycle.maximum_points_cents + (INCREASE_PER_LEVEL * current_cycle.maximum_points_cents / 100)
      else
        self.maximum_points_cents = impactable.maximum_points_for_level(next_level)
      end
    else # No current cycle means no previous cycle so we initialize with the default maximum
      self.maximum_points_cents = impactable.maximum_points_for_level(1)
    end
  end
end
