# requires all seeds files
Dir[File.join(Rails.root, 'db', 'seeds/**', '*.rb')].sort.each { |seed| load seed }

# Useful for dev: 
# Dir[File.join(Rails.root, 'db', 'seeds/apps', '*.rb')].sort.each { |seed| load seed }
# Dir[File.join(Rails.root, 'db', 'seeds/tasks.rb')].sort.each { |seed| load seed }
# Dir[File.join(Rails.root, 'db', 'seeds/', 'potential_apps.rb')].sort.each { |seed| load seed }

# Dir[File.join(Rails.root, 'db', 'seeds/criteria', 'dreamact.rb')].sort.each { |seed| load seed }
# Dir[File.join(Rails.root, 'db', 'seeds/criteria', 'lilo.rb')].sort.each { |seed| load seed }
# Dir[File.join(Rails.root, 'db', 'seeds/criteria', 'goodeed.rb')].sort.each { |seed| load seed }

# Seeds::Users.cleanup!
Seeds::Tasks.cleanup!
Seeds::Apps.cleanup!
Seeds::PotentialApps.cleanup!
Seeds::Perks.cleanup!

# users = Seeds::Users.seed!
tasks = Seeds::Tasks.seed!
apps = Seeds::Apps.seed!
potential_apps = Seeds::PotentialApps.seed!
# perks = Seeds::Perks.seed!
# earned_perks = Seeds::Perks::seed_relations!

# User.first.connected_applications.create!({
#   application: Application.first, 
#   email: User.first.email, 
#   encrypted_password: "wowmuchencryption"
# })

# User.first.connected_applications.create!({
#   application: Application.last, 
#   email: User.first.email, 
#   encrypted_password: "wowmuchencryption"
# })
