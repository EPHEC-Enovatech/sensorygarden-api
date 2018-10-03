# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, 'sensorygarden-api'
set :repo_url, 'git@github.com:EPHEC-Enovatech/sensorygarden-api.git'
set :deploy_to, '/var/www/api.sensorygarden.be'
set :user, 'deploy'
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets bundle}

namespace :deploy do 
    
    %w[start stop restart].each do |command|
        desc 'Manage Unicorn'
        task command do
            on roles(:app), in: :sequence, wait: 1 do
                execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
            end
        end
    end

    after :publishing, :restart

end