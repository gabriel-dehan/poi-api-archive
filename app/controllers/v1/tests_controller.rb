class V1::TestsController < ApplicationController
  access_level :public
  skip_before_action :authenticate_user!

  def test_notify
    Notifier.new(User.last).notify_new_app(Application.last)
  end

  def test_notify_level_reached
    Notifier.new(User.last).notify_level_reached
  end

  def test_daily_digest
    Notifier.new(User.find(params[:id])).send_daily_digest
  end


end
