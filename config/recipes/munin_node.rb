namespace :munin_node do

  desc "Install latest stable release of munin-node"
  task :install, roles: :db do
    run "#{sudo} apt-get -y install munin-node"
  end
  after "deploy:install", "munin_node:install"

  desc "Setup munin-node configuration for this application"
  task :setup, roles: :db do
    template "munin-node/munin-node.conf.erb", "/tmp/munin-node.conf"
    run "#{sudo} mv /tmp/munin-node.conf /etc/munin/munin-node.conf"
    restart
  end
  after "deploy:setup", "munin_node:setup"
  
  %w[start stop restart].each do |command|
    desc "#{command} munin-node"
    task command, roles: :db do
      run "#{sudo} service munin-node #{command}"
    end
  end
end