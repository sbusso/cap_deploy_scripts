set :jruby_path, "\"PATH=$PATH:#{jruby_bin_path}\""

namespace :jruby do

  desc "Install latest stable release of jruby"
  task :install, roles: [:app] do
    run "#{sudo} apt-get install -y openjdk-7-jdk"
    run "wget http://jruby.org.s3.amazonaws.com/downloads/#{jruby_version}/jruby-bin-#{jruby_version}.tar.gz"
    run "tar xvf jruby-bin-#{jruby_version}.tar.gz"
    run "sh -c 'echo export #{jruby_path} >> /home/ubuntu/.profile'"
    run "#{sudo} ln -s #{jruby_bin_path}/jruby /usr/local/bin/jruby"
    run "#{jruby_bin_path}/jruby -S gem install bundler"
    run "#{jruby_bin_path}/jruby -S gem install rake"
  end
  after "deploy:install", "jruby:install"

end
