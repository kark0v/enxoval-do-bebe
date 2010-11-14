require "bundler/capistrano"
#
# Application
#
set :application, "enxoval"
set :user, "simaob"
set :use_sudo, true
#set :user, "root"
#set :domain, "demoapps.unep-wcmc.org"
set :deploy_to, "/var/www/#{application}"
set :port, 30000
#
# Settings
#
default_run_options[:pty] = true # Must be set for the password prompt from git to work
#set :shared_path, "/"

#
# Git
#
set :repository, "git@github.com:kark0v/enxoval-do-bebe.git"

set :scm, :git
set :branch, "master"
#set :git_enable_submodules, 1
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_via, :remote_cache

#
# Servers
#
role :web, "77.235.60.163" # Your HTTP server, Apache/etc
role :app, "77.235.60.163" # This may be the same as your `Web` server
role :db, "77.235.60.163", :primary => true # This is where Rails migrations will run


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

#task to run to link the database files properly
task :setup_production_database_configuration do
  postgres_password = Capistrano::CLI.password_prompt("Production PostGres password: ")
  require 'yaml'
  spec = { "production" => {
                                   "adapter" => "postgresql",
                                   "database" => 'enxoval_production',
                                   "username" => 'enxoval',
                                   "password" => postgres_password }}
  run "mkdir -p #{shared_path}/config"
  put(spec.to_yaml, "#{shared_path}/config/database.yml")
end

#create the private folder in shared
#task :create_private_folder do
#  run "mkdir -p #{shared_path}/private"
#  run "chmod -R 775 #{shared_path}/private"
#  run "chown -R nobody #{shared_path}/private"
#end

#create folder to hold the headers.
#task :create_system_and_headers_folder do
#  run "mkdir -p #{shared_path}/system/headers"
#  run "chmod -R 775 #{shared_path}/system/headers"
#  run "chown -R nobody #{shared_path}/system/headers"
#end

task :create_sym_links do
  run "(rm #{release_path}/config/database.yml && ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml) || echo 'not ready for this'"
#  run "(rm -rf #{release_path}/private && ln -s #{shared_path}/private #{release_path}/private) || echo 'not ready for this'"
  run "(rm -rf #{release_path}/public/system && ln -s #{shared_path}/system #{release_path}/public/) || echo 'not ready for this'"
end

after "deploy:setup", :setup_production_database_configuration
#after "deploy:setup", :create_private_folder, :create_system_and_headers_folder
after "deploy:setup", :create_sym_links

#task :copy_production_database_configuration do
#  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#end
# after "deploy:update_code", :copy_production_database_configuration

after :deploy, "passenger:restart"

#task to run the prawn modules
#task :run_prawn_module_1 do
# run "cd /var/www/#{application}/current/vendor/prawn && git submodule init"
# run "cd /var/www/#{application}/current/vendor/prawn && git submodule update"
#  run "cd #{release_path}/vendor/prawn && git submodule init"
#  run "cd #{release_path}/vendor/prawn && git submodule update"
#end

#task :run_prawn_module_2 do
#  run "cd /var/www/#{application}/current/vendor/prawn && git submodule update"
#end

#task run delayed job
#task :run_delayed_job do
  #run "cd /var/www/#{application}/current && RAILS_ENV=production script/delayed_job start"
#  run "cd /var/www/#{application}/current && RAILS_ENV=production script/delayed_job stop && RAILS_ENV=production script/delayed_job run &"
#end
#after "deploy:update_code", :run_prawn_module_1
#after "deploy:update_code", :create_sym_links, :run_delayed_job

