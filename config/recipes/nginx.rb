namespace :nginx do

  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    run "#{sudo} apt-get -y install nginx"
    run "#{sudo} rm /etc/nginx/sites-enabled/default"
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx/myapp.conf.erb", "/tmp/myapp.conf"
    run "#{sudo} mv /tmp/myapp.conf /etc/nginx/sites-available/my_app.conf"
    template "nginx/nginx.conf.erb", "/tmp/nginx.conf"
    run "#{sudo} mv /tmp/nginx.conf /etc/nginx/nginx.conf"
    run "#{sudo} ln -sf /etc/nginx/sites-available/my_app.conf /etc/nginx/sites-enabled/my_app.conf"
    restart
  end
  after "deploy:setup", "nginx:setup"
  
  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end