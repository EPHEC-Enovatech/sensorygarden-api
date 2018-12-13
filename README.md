# SensoryGarden REST API

## Useful links

| | |
|-|-|
| Deployment | [![Build Status](https://travis-ci.org/EPHEC-Enovatech/sensorygarden-api.svg?branch=master)](https://travis-ci.org/EPHEC-Enovatech/sensorygarden-api) |
| Code Quality | [![Maintainability](https://api.codeclimate.com/v1/badges/31bcd0b9eb34f18ce1c4/maintainability)](https://codeclimate.com/github/EPHEC-Enovatech/sensorygarden-api/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/31bcd0b9eb34f18ce1c4/test_coverage)](https://codeclimate.com/github/EPHEC-Enovatech/sensorygarden-api/test_coverage) |
| Availability | [![Uptime Robot status](https://img.shields.io/uptimerobot/status/m781197194-91bd11d1d9716b993f6ab7ea.svg)](https://stats.uptimerobot.com/3wxA3hqAA) [![Uptime Robot ratio (30 days)](https://img.shields.io/uptimerobot/ratio/m781197194-91bd11d1d9716b993f6ab7ea.svg)](https://stats.uptimerobot.com/3wxA3hqAA) |
| Code frequency | ![GitHub last commit](https://img.shields.io/github/last-commit/EPHEC-Enovatech/sensorygarden-api.svg) |
| Documentation | [![Documentation](https://img.shields.io/badge/API-Documentation-red.svg)](https://documenter.getpostman.com/view/4801562/RzZ3LhFG)

## Explanation

This API was delevopped with Ruby on Rails on a period on three months for a school project. 
We used it to insert data coming from an IoT module we developped and to then fetch this data from a Progressive Web App

## Technologies

Here's a non-exhaustive list of the technologies and dependencies used 

- Ruby on Rails 5
- MySQL
- JWT (with the Knock gem)
- Unicorn (for production server)
- Nginx (Reverse Proxy)
- Capistrano (Deployment)
- Travis-CI (Continuous deployment)

## Prerequirements

You'll need Ruby 2.5.1 or higher and Ruby on Rails 5.2.1 or higher installed on your device.
You also need some sort of SGBD installed, for example MySQL, Postgres, MariaDB, SQlite, ...

## Installation & Configuration

First clone the repository to your device : 
```
$ git clone https://github.com/EPHEC-Enovatech/sensorygarden-api.git
```

Then inside the cloned repository, you need to change some configuration parameters. 
In `/config/database.yml` change in the development settings the username and password :
```yaml
development:
  <<: *default
  database: sensorygarden_api_development
  username: {{YOUR USERNAME}}
  password: {{YOUR PASSWORD}}
```

Following the SGBD you choosed to install you'll need to change the database adapter. 
In `/config/database.yml` change in the default section : 
```yaml
default: &default
  adapter: {{eg: pg, mysql2, sqlite3, ...}}
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: localhost
```
Full list of available database adapters [here](https://www.ruby-toolbox.com/categories/SQL_Database_Adapters).

Then you need to setup the database with the command :
```
$ bundle exec rake db:setup
```

You can now start a development server with the command :
```
$ rails s
```

The API is now accessible at `localhost:3000`


