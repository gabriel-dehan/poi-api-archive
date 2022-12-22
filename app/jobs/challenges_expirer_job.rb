class ChallengesExpirerJob < ApplicationJob
  queue_as :default

  def perform
    FriendsChallenge.where(status: "accepted").where("end_date < ?", Date.today).update_all(status: "expired")
  end
end
