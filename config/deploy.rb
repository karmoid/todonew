set :default_environment, {
  'PATH' => "~/.rvm/gems/ruby-1.9.2-p180/bin:~/.rvm/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.2',
  'GEM_HOME'     => '~/.rvm/gems/ruby-1.9.2-p180',
  'GEM_PATH'     => '~/.rvm/gems/ruby-1.9.2-p180',
  'BUNDLE_PATH'  => '~/.rvm/gems/ruby-1.9.2-p180'  # If you are using bundler.
}
# RVM bootstrap
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'capistrano'
set :rvm_ruby_string, '1.9.2-p180'
set :rvm_type, :user

# bundler bootstrap
require 'bundler/capistrano'

# main details
set :application, "wapatoo.homelinux.org"
role :web, application
role :app, application
role :db,  application, :primary => true

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/var/www/apps/wapatoo.homelinux.org"
set :deploy_via, :remote_cache
set :user, "passenger"
set :use_sudo, false

# repo details
set :scm, :git
set :scm_username, "passenger"
set :repository, "git@github.com:karmoid/todonew.git"
set :branch, "master"
set :git_enable_submodules, 1

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  
  task :copy_database_configuration do
	production_config = "/home/passenger/config-src/"
	production_db_config = "#{production_config}database.yml"
	production_env_config = "#{production_config}production.rb"
	run "cp #{production_db_config} #{release_path}/config/database.yml && cp #{production_env_config} #{release_path}/config/environments/production.rb"
  end
end

# after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:update_code' , 'deploy:copy_database_configuration'  
