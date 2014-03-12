server 'example.com', :app, :web, :db, primary:true

set :domain, 'example.com'

set :rails_env, 'production'

#set :port, 22
set :user, 'deployer'

set :deploy_to, "/opt/#{application}"
set :shared_path, "#{deploy_to}/shared"

set :branch, 'master'
