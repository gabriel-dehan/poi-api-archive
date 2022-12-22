namespace :notifications do
  desc "rake notifications:daily_digest"
  task daily_digest: :environment do
    DailyDigestNotifierJob.perform_later
  end

end
