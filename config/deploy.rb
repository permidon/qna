# config valid only for current version of Capistrano
lock "3.8.0"

set :application, 'qna'
set :repo_url, 'git@github.com:permidon/qna.git'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'


# Default value for :linked_files is []
set :linked_files, %w{config/database.yml .env config/thinking_sphinx.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :default_shell, '/bin/bash -l'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end