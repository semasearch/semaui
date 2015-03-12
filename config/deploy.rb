require 'pry'
set :application, "semasearch"
set :deploy_to, "/var/www/#{fetch(:application)}"

set :git_strategy, RemoteCacheWithProjectRootStrategy
set :project_root, 'sema_dev'

#set :default_env, { rvm_bin_path: '~/.rvm/bin' }

set :user, 'root'

set :scm, :git
set :repo_url, 'git@bitbucket.org:pvmedical/semasearch.git'


set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp public/uploads}

# http://stackoverflow.com/questions/21036175/how-to-deploy-a-specific-revision-with-capistrano-3
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || 'master'

set :ssh_options, {
  auth_methods: %w(publickey)
}


namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "/etc/init.d/semasearch restart"
    end
  end
  task :create_uploads_folder do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/public/uploads"
    end
  end

  before :starting, :create_uploads_folder

  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'

end

namespace :semasearch do

  desc "create db and seed data"
  task :create_db do
    on roles(:app) do
      execute "cd #{release_path} && RAILS_ENV=#{fetch(:stage).to_s} bundle exec rake db:create"
      execute "cd #{release_path} && RAILS_ENV=#{fetch(:stage).to_s} bundle exec rake db:seed"
    end
  end

end