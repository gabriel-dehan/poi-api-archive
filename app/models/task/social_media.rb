class Task::SocialMedia < TaskBlueprint
  def should_trigger_event?
    true
  end
end