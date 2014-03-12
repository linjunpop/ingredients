namespace :puma do
  task :start, :except => { :no_release => true } do
    run "#{sudo} start puma app=#{current_path}"
  end
  after "deploy:start", "puma:start"

  task :stop, :except => { :no_release => true } do
    run "#{sudo} stop puma app=#{current_path}"
  end
  after "deploy:stop", "puma:stop"

  task :restart, roles: :app do
    run "#{sudo} restart puma app=#{current_path}"
  end
  after "deploy:restart", "puma:restart"

  desc 'install puma upstart script'
  task :install, roles: :web do
    run "#{sudo} bash -c 'curl https://raw.github.com/puma/puma/master/tools/jungle/upstart/puma-manager.conf > /etc/init/puma-manager.conf'"
  end
  after 'deploy:install', 'puma:install'

  desc 'Setup puma config'
  task :setup, roles: :web do
    template 'puma.conf.erb', "#{shared_path}/puma_conf"
    run "#{sudo} mv #{shared_path}/puma_conf /etc/init/puma.conf"
    run "#{sudo} bash -c 'echo #{current_path} >> /etc/puma.conf'"
  end
  after 'deploy:setup', 'puma:setup'
end
