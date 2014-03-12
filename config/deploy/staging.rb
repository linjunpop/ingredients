server 'example.com', :app, :web, :db, primary: true

set :domain, 'example.com'

set :rails_env, 'staging'

set :port, 22
set :user, 'user'

set :deploy_to, "/opt/#{application}"
set :shared_path, "#{deploy_to}/shared"

set :branch, current_git_branch

def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{branch}"
  branch
end
