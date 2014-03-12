require 'capistrano/ext/multistage'
require 'capistrano_colors'
require 'bundler/capistrano'

load 'config/deploy/recipes/base'
load 'config/deploy/recipes/rvm'
load 'config/deploy/recipes/nginx'
load 'config/deploy/recipes/mongo'
load 'config/deploy/recipes/nodejs'
load 'config/deploy/recipes/puma'
load 'config/deploy/recipes/figaro'
load 'config/deploy/recipes/newrelic'

set :stages, %w(staging production)
set :default_stage, 'staging'

set :application, Rails.application.class.parent_name

set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, :git
set :repository, ''
set :scm_verbose, true
set :checkout, 'export'

default_run_options[:pty] = true
set :ssh_options, { forward_agent: true }

after 'deploy', 'deploy:cleanup' # keep only last 5 release

set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }
require "whenever/capistrano"

namespace :deploy do
  desc "Create socket file symlink"
  task :symlink_sockets, :except => {:no_release => true} do
    run "mkdir -p #{shared_path}/sockets"
    run "ln -s #{shared_path}/sockets #{release_path}/tmp/sockets"
  end
end
after 'deploy:update', 'deploy:symlink_sockets'
