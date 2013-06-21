set :mms_api_key, "TEST_KEY"
set :mms_secret_key, "TEST_KEY"

namespace :mms_agent do

  desc "Install latest stable release of mms_agent"
  task :install, roles: :db do
    run "#{sudo} apt-get -y install python-setuptools build-essential python-dev"
    run "#{sudo} easy_install pymongo"
    run "wget https://mms.10gen.com/settings/10gen-mms-agent.tar.gz"
    run "tar xvf 10gen-mms-agent.tar.gz"
    start
  end
  after "deploy:install", "mms_agent:install"

  desc "Setup mms_agent configuration for this application"
  task :setup, roles: :db do
    run "sed -i 's/@API_KEY@/#{mms_api_key}/g' /home/#{user}/mms-agent/settings.py"
    run "sed -i 's/@SECRET_KEY@/#{mms_secret_key}/g' /home/#{user}/mms-agent/settings.py"
    restart
  end
  after "deploy:setup", "mms_agent:setup"
  
  desc "start mms_agent"
  task :start, roles: :db do
    # Add a sleep to the end of the command, so python has enough time to startup...
    run "sh -c '(cd /home/#{user}/mms-agent && nohup python agent.py > /home/#{user}/mms_agent.log 2>&1 &) && sleep 1'"
  end

  desc "stop mms_agent"
  task :stop, roles: :db do
    run "#{sudo} pkill python"
  end

  desc "restart mms_agent"
  task :restart, roles: :db do
    stop
    start
  end

end