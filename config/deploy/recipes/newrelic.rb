require 'new_relic/recipes'

namespace :newrelic do
  desc 'Install Newrelic server monitor package'
  task :install, roles: :web do
    run "#{sudo} wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list"
    run "wget -O- https://download.newrelic.com/548C16BF.gpg | #{sudo} apt-key add -"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install newrelic-sysmond"
  end
  after 'deploy:install', 'newrelic:install'

  desc 'Setup Newrelic server monitor'
  task :setup, roles: :web do
    set(:license_key) { Capistrano::CLI.ui.ask("Newrelic License Key: ") }
    run "#{sudo} nrsysmond-config --set license_key=#{license_key}"
    restart
  end
  after 'deploy:setup', 'newrelic:setup'

  %w[start stop restart].each do |command|
    desc "#{command} newrelic-sysmond"
    task command, roles: :db do
      run "#{sudo} service newrelic-sysmond #{command}"
    end
  end
end
