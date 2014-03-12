namespace :figaro do
  task :config do
    raise 'Can not read config file' unless File.exist?('config/application.yml')
    run_locally %Q(rails runner 'puts Figaro.env("#{stage}").to_yaml' > _application_.yml)
    transfer :up, '_application_.yml', "#{shared_path}/application.yml", via: :scp
    run "ln -sf #{shared_path}/application.yml #{current_release}/config/application.yml"
    run_locally 'rm _application_.yml'
  end
end

after 'deploy:update_code', 'figaro:config'
