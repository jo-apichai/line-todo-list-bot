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

## Usage

### Add new task

Send a text message in `task : date : time` pattern to chat bot. (e.g. `Watch movie : 15/6/18 : 15:00`)

#### Parameters


| Parameter | Required | Description                                                       |
|:---------:|:--------:|-------------------------------------------------------------------|
| task      |     ✓    | Description of the task                                           |
| date      |     ✓    | Date in `d/m/yy` format (e.g. `15/6/18`) or `today` or `tomorrow` |
| time      |          | Time in `HH:mm` format (e.g. `15:30`). Default value is `12:00`   |

### Edit task

Send a text message with word `edit` to chatbot and it will send edit link back to you.
