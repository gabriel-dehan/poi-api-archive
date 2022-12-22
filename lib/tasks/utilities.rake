namespace :utilities do

  desc "rake utilities:clean_duplicated_events"
  task clean_duplicated_events: :environment do
    ThreadedConfig.silent = true 

    User.all.each do |user|
      puts "User <##{user.id} #{user.email}>"
      evts = user.events.where(type: 'action')
      puts "Finding duplicated events..."
      unique_events = evts.uniq do |event|
        [event.application_id, event.parameters, event.category, event.impact_points_cents]
      end

      if (evts - unique_events).any?
        # Destroy duplicated events
        puts "Destroying duplicated events!"
        user.events.where(type: 'action').where.not(id: unique_events.map(&:id)).destroy_all
      end
      puts "Done!"
    end

    ThreadedConfig.silent = false
  end

  desc "rake utilities:replay_events"
  task replay_events: :environment do
    ThreadedConfig.silent = true 

    User.all.each do |user|
      puts "User <##{user.id} #{user.email}>"
      # Resets impact and gauges
      puts "Reseting user's impacts"
      impact = user.impact 
      # TODO: events are attached to an impact but it should not, see user.rb:55
      events = user.events 

      user.impact = nil
      user.save! 

      impact.destroy!
      user.send(:setup_impact)
      user.save!
      
      puts "Replaying user's events"
      events.each do |event| 
        event.send(:process_impact_change)
      end 
      puts "Done!"
    end

    ThreadedConfig.silent = false
  end

end
