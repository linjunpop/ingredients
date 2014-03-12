namespace :mongo do
  desc 'Install latest stable release of MongoDB'
  task :install, roles: :db do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install mongodb"
  end
  after 'deploy:install', 'mongo:install'

  desc 'setup mongodb/mongoid configuration'
  task :setup, roles: :db do
    set(:mongodb_database) { Capistrano::CLI.ui.ask("MongoDB Database: ") }
    set(:mongodb_username) { Capistrano::CLI.ui.ask("MongoDB Username: ") }
    set(:mongodb_password) { Capistrano::CLI.ui.ask("MongoDB Password: ") }

    template 'mongoid.yml.erb', "#{shared_path}/mongoid.yml"

    run <<-eos
      #{sudo} mongo --eval "db.getSiblingDB('#{mongodb_database}').addUser('#{mongodb_username}', '#{mongodb_password}')"
    eos
    template 'mongodb.conf.erb', "#{shared_path}/mongodb_conf"
    run "#{sudo} mv #{shared_path}/mongodb_conf /etc/mongodb.conf"
    restart
  end
  after 'deploy:setup', 'mongo:setup'

  %w[start stop restart].each do |command|
    desc "#{command} mongodb"
    task command, roles: :db do
      run "#{sudo} service mongodb #{command}"
    end
  end

  desc "Create indexes of all models"
  task :create_indexes do
    run "cd #{current_path} && RAILS_ENV=#{stage} bundle exec rake db:mongoid:create_indexes"
  end
  after "deploy:update", "mongo:create_indexes"

  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/mongoid.yml #{release_path}/config/mongoid.yml"
  end
  after "deploy:finalize_update", "mongo:symlink"
end
