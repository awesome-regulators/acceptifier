require 'capistrano_colors'
require 'bundler/capistrano'

set :application, "acceptifier"
set :repository,  "git@github.com:awesome-regulators/acceptifier.git"
set :branch, 'deploy'

set :use_sudo, false

set :scm, 'git'

set :user, "deploy"
set :password, "d3pl0y"

set :deploy_to, "/home/deploy/apps/acceptifier"

set :domain, 'acceptifier.integrumdemo.com'
set :rails_env, 'production'

role :web, "acceptifier.integrumdemo.com"                          # Your HTTP server, Apache/etc
role :db,  "acceptifier.integrumdemo.com", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
after "deploy:update_code", "deploy:symlinks"
after "deploy:update_code", "deploy:migrate"
after "deploy:update_code", "deploy:precompile_assets"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "precompile the assets"
  task :precompile_assets, :roles => :web, :except => { :no_release => true } do
    run "cd #{release_path}; rm -rf public/assets/*"
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
  desc "Create symlinks"
  task :symlinks, :roles => :web, :except => {:no_release => true} do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

require './config/boot'
