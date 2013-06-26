namespace :puma do

  desc "start puma"
  task :start, roles: :app do
    run "sh -c '(export RAILS_ENV=production && cd /home/#{user}/apps/#{application}/current && nohup #{bundle_cmd} exec puma -e production -b unix:///home/#{user}/apps/#{application}.sock --pidfile /home/#{user}/apps/#{application}.pid &) && sleep 1'"
  end

  desc "stop puma"
  task :stop, roles: :app do
    run "#{sudo} kill -9 `cat /home/#{user}/apps/#{application}.pid`"
  end
end