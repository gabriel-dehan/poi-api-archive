namespace :challenges do
  desc "rake challenges:check_expiration"
  task :check_expiration => :environment do
    ChallengesExpirerJob.perform_later
  end

end
