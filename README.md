# dbcp

Copy Postgres databases between application environments.

Setting an employee up to work on a web application for the first time is time consuming. Tools like [Vagrant](http://www.vagrantup.com) have made it easy to get your environment setup, but you still need to get your relational database setup. In rails you can load your `db/schema.rb` and hope that `db/seeds.rb` is well curated, but seldom has enough to let a developer hit the ground running. Working with your production database while developing is extremely convenient. The [parity](http://12factor.net/dev-prod-parity) helps preview database performance. It also makes investigating data-specific bugs much easier. The goal of `dbcp` is to make copying databases between development, staging, and production environments as easy as copying a file on your local disk.

## A word of caution

Depending on your application, your production database may contain sensitive personal information like financial or health data. Give careful consideration to the risks of using production data on staging and development environments, and whether it's acceptable to use a tool like this in your application's workflow.

Treat your production database like a loaded gun. Consider employing some of these safe guards:

- Use a separate account that only has read access.
- Access a replication "follower" instead of the master.
- Access a completely separate database that is periodically populated from production, but is updated to use fake values for sensitive information.

## Installation

`dbcp` is a stand-alone utility. To install, just run:

    $ gem install dbcp

You should __not__ need to include dbcp in your `Gemfile`.

## Usage

To copy the production database to the development environment, simply run:

    $ dbcp production development

Environment credentials can be defined in the following providers:

### config/database.yml

Rails defines credentials for its database environments in a file at [`config/database.yml`](https://github.com/rails/rails/blob/master/guides/code/getting_started/config/database.yml). By default this file is generated with only development and test environments, but any additional environments added will be leveraged by `dbcp`. Although this is a rails convention, `dbcp` parses this file outside of any framework, so it will work even if you're using this convention in another framework.

## Roadmap

The following features are pending:

Providers:

- URL passed in as environment
- capistrano task
- heroku, inferred from git remotes

Features:

- Execution from remote hosts over ssh
- Reading configuration from a remote config/database.yml
- MySQL support
- Definable per-tool specific options, e.g. to allow pg_dump to provide a table exclusion list
