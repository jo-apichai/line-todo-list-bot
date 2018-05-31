# LINE Todo List Bot

LINE Bot backend for managing todo list

## Getting Started

These instructions will setup an environment for development and testing on your local machine.

### Prerequisites

Install [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) on your machine.

### Installing

- Clone this repo to your local machine
- Get master key and put it in `config/master.key`
- Create docker images and start containers
```bash
# Create docker images
docker-compose build

# Start docker containers
docker-compose up
```
- Run rake task to create database and migrate schema
```bash
# Create database
docker-compose run app bundle exec rake db:create

# Migrate schema
docker-compose run app bundle exec rake db:migrate
```
