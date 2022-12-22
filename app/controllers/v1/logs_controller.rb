class V1::LogsController < ApplicationController
  access_level :public 

  class AppCrashError < StandardError; end

  def app_logger 
    Raven.capture do
      # {"error"=>{"line"=>1651, "column"=>830, "sourceURL"=>"index.android.bundle"}, "isIOS"=>false, "isAndroid"=>true, "log"=>{"error"=>{"line"=>1651, "column"=>830, "sourceURL"=>"index.android.bundle"}, "isIOS"=>false, "isAndroid"=>true}}#
      # p error_payload
      p "====== APP CRASH ======="
      raise AppCrashError

    end
    
    head :no_content
  end

  def bug_reported 
    # Trigger the reward for the Task
    current_user.action_taken!(Task::BugReport)
  end

end
