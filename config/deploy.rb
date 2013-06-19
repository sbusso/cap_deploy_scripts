set :application, "palamedes"
set :repository,  "git@github.com:denniskuczynski/#{application}.git"
set :branch, "master"
set :user, "ubuntu"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = ["~/Documents/keys/palamedes.pem"]

load "config/recipes/base"
load "config/recipes/munin_node"
load "config/recipes/mongodb"
load "config/recipes/mms_agent"
load "config/recipes/monit"

#role :web, "your web-server here"                          
#role :app, "your app-server here"                          
role :db,  "ec2-54-226-230-123.compute-1.amazonaws.com"

after "deploy", "deploy:cleanup" # keep only the last 5 releases

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end