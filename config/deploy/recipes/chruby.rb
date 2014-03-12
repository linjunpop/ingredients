namespace :chruby do
  set :chruby_version, '0.3.8'
  set :ruby_install_version, '0.4.0'

  desc 'install chruby'
  task :install, roles: :app do
    run "wget -O chruby-#{chruby_version}.tar.gz https://github.com/postmodern/chruby/archive/v#{chruby_version}.tar.gz"
    run "tar -xzvf chruby-#{chruby_version}.tar.gz"
    run "cd chruby-#{chruby_version}; #{sudo} make install"
  end
  after 'deploy:install', 'chruby:install'

  desc 'install ruby-install'
  task :install_ruby_install, roles: :app do
    run "wget -O ruby-install-#{ruby_install_version}.tar.gz https://github.com/postmodern/ruby-install/archive/v#{ruby_install_version}.tar.gz"
    run "tar -xzvf ruby-install-#{ruby_install_version}.tar.gz"
    run "cd ruby-install-#{ruby_install_version}; #{sudo} make install"

    run "ruby-install ruby #{ruby_version}"
  end
  after 'chruby:install', 'chruby:install_ruby_install'
end

set :ruby_version, -> { File.read('.ruby-version').chop }
set :chruby_config, "/usr/local/share/chruby/chruby.sh"
set :set_ruby_cmd, "source #{chruby_config} && chruby #{ruby_version}"
set(:bundle_cmd) {
  "#{set_ruby_cmd} && RAILS_ENV=#{rails_env} exec bundle"
}
