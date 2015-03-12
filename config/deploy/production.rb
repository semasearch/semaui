set :stage, :production
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || 'master'
role :app, %w{root@37.139.6.115}
role :web, %w{root@37.139.6.115}
role :db,  %w{root@37.139.6.115}
server '37.139.6.115', user: 'root', roles: %w{web app}
after 'deploy:published', 'deploy:restart'