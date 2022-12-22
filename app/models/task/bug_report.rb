class Task::BugReport < TaskBlueprint
  def should_trigger_event?
    true
  end
end