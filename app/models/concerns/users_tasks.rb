module UsersTasks
  extend ActiveSupport::Concern

  INITIAL_TASKS = [
    Task::BetaTester, 
    Task::Invite, 
    Task::Blogging, 
    Task::SocialMedia, 
    Task::BugReport
  ]

  included do
    has_many :assigned_tasks, dependent: :destroy
    has_many :task_blueprints, through: :assigned_tasks
    alias_attribute :tasks, :task_blueprints # convenient 
    
    after_create :assign_initial_tasks
  end

  # take_action!(Task::GettingeReferred)
  def action_taken!(task_blueprint_class)
    assigned_task = find_assigned_task(task_blueprint_class)

    assigned_task.action_taken! if assigned_task
  end

  # Retrieves a task by blueprint, eg: find_task(Task::GettingReferred)
  def find_assigned_task(task_blueprint_class)
    self.assigned_tasks.find_by(task_blueprint: task_blueprint_class.get)
  end

  def assign_initial_tasks 
    unless assigned_tasks.any?
      INITIAL_TASKS.map { |task| task.get.assign(self) }

      # TODO: Remove after beta test
      self.action_taken!(Task::BetaTester)
    end
  end
end