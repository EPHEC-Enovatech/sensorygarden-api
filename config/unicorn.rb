require 'rubygems'
require 'rails'
require 'knock'
require 'rack/cors'

root = "/var/www/api.sensorygarden.be/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.sensorygarden-api.sock"
worker_processes 1
timeout 30
