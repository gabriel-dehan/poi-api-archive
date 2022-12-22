module Seeds
  module Tasks
    def self.cleanup!
      TaskBlueprint.destroy_all unless Rails.env.production?
    end

    def self.seed!
      Task::BetaTester.create({
        name: "tasks.beta_tester.name",
        description: "tasks.beta_tester.description",
        category: "initial",
        reward_cents: 1000,
        maximum_occurence: 1,
      })

      Task::Invite.create({
        name: "tasks.invite.name",
        description: "tasks.invite.description",
        category: "referral",
        reward_cents: 1000,
      })

      Task::Blogging.create({
        name: "tasks.blogging.name",
        description: "tasks.blogging.description",
        category: "social",
        reward_cents: 2500
      })

      Task::SocialMedia.create({
        name: "tasks.social_media.name",
        description: "tasks.social_media.description",
        category: "social",
        reward_cents: 500,
        maximum_occurence: 50
      })

      Task::BugReport.create({
        name: "tasks.bug_report.name",
        description: "tasks.bug_report.description",
        category: "bounty",
        reward_cents: 500
      })
    end
  end
end