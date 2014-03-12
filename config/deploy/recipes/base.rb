def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc 'Install everything onto the server'
  task :install do
    run "#{sudo} mkdir -p #{deploy_to}"
    run "#{sudo} chown -R #{user} #{deploy_to}"
    run "#{sudo} locale-gen en_US.UTF-8"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install software-properties-common"
  end
end