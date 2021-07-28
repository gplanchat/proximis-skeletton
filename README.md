# Akeneo to Proximis

## TL;DR

This repository aims ait helping you connect your Akeneo PIM to a Proximis e-commerce solution.
In this matter, the data contained in akeneo (products, categories, families, attributes, images, etc.)
is transferred to Proximis's data manager through FTP and CSV files.

## Base principles

This project uses [Kiboko Middleware's compiler](https://github.com/php-etl/satellite) in order to build data pipelines.
Those pipelines are built to transform **Akeneo**'s API data into **Proximis**' CSV file format, therefore you will be able to 
import those files either through the **Data Manager**, or send them through FTP. 

Each pipeline is declared in a separate folder, we use a makefile to orchestrate the compilation and execution of all of
them in the right order. Each data flow is independent of the others, it is defined by a `satellite.yaml` file you can
customize following your business needs and constraints. Those files are used by the compiler to build a separate and
independent PHP CLI script aimed at being run from a crontab, a scheduler or your shell.

## Installation

### System dependencies

- PHP >= 8.0
- Composer 2
- An ElasticStack (ElasticSearch + Kibana) installation (check [Docker installation instructions](#using-docker) if you need a quick start)

If you are a developer, you may also need those tools: 

- xdebug PHP extension
- Postman with Akeneo's collection and environments
  - [Collection](https://api.akeneo.com/files/Akeneo%20PIM%20API.postman_collection.json)
  - [Environment](https://github.com/akeneo/pim-api-docs/blob/master/content/files/akeneo-PIM-API-environment-4x.postman_environment.json)  

### Installation

- `git clone git@github.com:php-etl/proximis-skeletton.git your-project`
- `cd your-project`
- `composer install`

#### Using Docker

If you are using docker, you may also need to run `docker compose up -d`. If you have an error related to networking or
ports availability, you may need  to create an `.env` file to change the default ports.

Environment variables are the following:
- `ELASTICSEARCH_PORT` for ElesticSearch's public API port (default: 9200)
- `KIBANA_PORT` for Kibana's public UI port (default: 5601)

## Using the connector

At the root of the project, there is a makefile you can use to reduce the amount of actions required to make the
middleware work.

Run `make` to run the middleware. If you did not compile it beforehand, it will be automatically built before being executed.

### Building your scripts

Run `make build`
