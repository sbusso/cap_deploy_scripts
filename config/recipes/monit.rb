namespace :monit do

  desc "Install latest stable release of monit"
  task :install, roles: [:db, :web] do
    run "#{sudo} apt-get -y install monit"
  end
  after "deploy:install", "monit:install"

  desc "Setup monit configuration for this application"
  task :setup, roles: [:db, :web] do
    template "monit/monitrc.erb", "/tmp/monitrc"
    run "#{sudo} mv /tmp/monitrc /etc/monit/monitrc"
    run "#{sudo} chown root /etc/monit/monitrc"
    run "#{sudo} chmod 600 /etc/monit/monitrc"
    restart
  end
  after "deploy:setup", "monit:setup"
  
  %w[start stop restart].each do |command|
    desc "#{command} monit"
    task command, roles: [:db, :web] do
      run "#{sudo} service monit #{command}"
    end
  end
end