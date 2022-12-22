class DailyDigestNotifierJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      Notifier.new(user).send_daily_digest
    end
  end
end
