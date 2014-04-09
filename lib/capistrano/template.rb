def template(from, to)
  erb = File.read("lib/capistrano/templates/#{from}")
  upload! StringIO.new(ERB.new(erb).result(binding)), to
end
