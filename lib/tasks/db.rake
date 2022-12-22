namespace :db do
  desc "rake db:import_json"
  task :import_json => :environment do
    ThreadedConfig.silent = true

    # if Rails.env.development?
    #   KnownContact.destroy_all
    #   Event.destroy_all
    #   Invite.destroy_all
    #   User.all.each { |user| user.referrer_id = nil; user.referrer = nil; user.destroy! }
    # end 

    data = JSON.parse(File.read("#{Rails.root}/db/poi-app.json"), object_class: OpenStruct)
    
    data.each do |user| 
      new_user = User.where(email: user.email).first_or_initialize do |u| 
        u.password = user.encrypted_password # for validation to pass
        u.provider = user.provider || "email"
        u.uid = user.uid || user.email

        u.full_name = "#{user.first_name} #{user.last_name}".strip
        u.full_name = "Anonymous" if u.full_name.blank?
        
        u.phone_number = "data_needed##{user.id}"
      end
      new_user.locale = user.locale

      # Ensures the referral was rewarded
      got_referred = user.taken_actions.find { |ta| ta.task_instance.type == "Task::GettingReferred" }

      if got_referred 
        referrer = User.find_by(email: user.referrer.email)
        new_user.referrer_code = referrer.referral_code
      end
      new_user.save!

      # update password after validation has passed
      new_user.update(encrypted_password: user.encrypted_password)
    end
    
    ThreadedConfig.silent = false
  end

  desc "Truncate all existing data"
  task :truncate => :environment do
    DatabaseCleaner.clean_with :truncation
  end

  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil
    with_config do |app, db|
      cmd = "pg_dump --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = nil
    with_config do |app, db|
      cmd = "pg_restore --verbose --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:database]
  end
end
