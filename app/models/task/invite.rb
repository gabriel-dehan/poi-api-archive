# Referral
class Task::Invite < TaskBlueprint
  def should_trigger_event?
    true
  end
end