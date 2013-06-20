set_default :xgen_source, '"deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen"'

namespace :mongodb do

  desc "Install latest stable release of mongodb"
  task :install, roles: :db do
    run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
    run "#{sudo} sh -c 'echo #{xgen_source} > /etc/apt/sources.list.d/10gen.list'"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install mongodb-10gen"
  end
  after "deploy:install", "mongodb:install"

  desc "Setup mongodb configuration for this application"
  task :setup, roles: :db do
    template "mongodb/mongodb.conf.erb", "/tmp/mongodb.conf"
    run "#{sudo} mv /tmp/mongodb.conf /etc/mongodb.conf"
    restart
  end
  after "deploy:setup", "mongodb:setup"
  
  %w[start stop restart].each do |command|
    desc "#{command} mongodb"
    task command, roles: :db do
      run "#{sudo} service mongodb #{command}"
    end
  end
end