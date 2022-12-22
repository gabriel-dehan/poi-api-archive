class Task::Blogging < TaskBlueprint
  def should_trigger_event?
    true
  end
end