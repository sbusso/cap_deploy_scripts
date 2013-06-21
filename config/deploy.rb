set :application, "sixpointprime"
set :repository,  "git@github.com:denniskuczynski/#{application}.git"
set :branch, "master"
set :user, "ubuntu"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :jruby_version, '1.7.4'
set :jruby_bin_path, "/home/#{user}/jruby-#{jruby_version}/bin"

set :rake, "#{jruby_bin_path}/jruby -S bundle exec rake --trace"
set :bundle_cmd, "#{jruby_bin_path}/jruby -S bundle"

default_run_options[:shell] = '/bin/bash'
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = ["~/Documents/keys/palamedes.pem"]

require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/munin_node"
load "config/recipes/mongodb"
load "config/recipes/mms_agent"
load "config/recipes/nginx"
load "config/recipes/jruby"

server "ec2-54-224-98-104.compute-1.amazonaws.com", :db, :web, :app

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
