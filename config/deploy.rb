set :application, "sixpointprime"
set :repository,  "git@github.com:denniskuczynski/#{application}.git"
set :branch, "master"
set :user, "ubuntu"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = ["~/Documents/keys/palamedes.pem"]

require "bundler/capistrano"

set :rvm_ruby_string, '1.9.3'
set :rvm_autolibs_flag, "read-only"
set :rvm_type, :system
set :rvm_install_with_sudo, true
set :rvm_require_role, :app
before 'deploy:install', 'rvm:install_rvm'
before 'deploy:install', 'rvm:install_ruby'
require "rvm/capistrano"

load "config/recipes/base"
load "config/recipes/munin_node"
load "config/recipes/mongodb"
load "config/recipes/mms_agent"
load "config/recipes/nginx"
load "config/recipes/puma"
load "config/recipes/monit"

server "ec2-54-243-25-79.compute-1.amazonaws.com", :db, :web, :app

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
