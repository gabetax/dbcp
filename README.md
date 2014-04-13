# dbcp

[![Build Status](https://travis-ci.org/gabetax/dbcp.svg?branch=master)](https://travis-ci.org/gabetax/dbcp)
[![Code Climate](https://codeclimate.com/github/gabetax/dbcp.png)](https://codeclimate.com/github/gabetax/dbcp)

Copy Postgres or MySQL databases between application environments.

Setting an employee up to work on a web application for the first time is time consuming. Tools like [Vagrant](http://www.vagrantup.com) have made it easy to get your environment setup, but you still need to get your relational database setup. In rails you can load your `db/schema.rb` and hope that `db/seeds.rb` is well curated, but seldom has enough to let a developer hit the ground running. Working with your production database while developing is extremely convenient. The [parity](http://12factor.net/dev-prod-parity) helps preview database performance. It also makes investigating data-specific bugs much easier.

The goal of `dbcp` is to make copying databases between development, staging, and production environments as easy as copying a file on your local disk. It's an adapter for platform-specific utilities like `pg_dump` and `mysqldump`, simplifies lookup of credentials using storage mechanisms you're already using, and handles transfer of dump files between hosts.

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

The database export or import can be executed on a remote host over ssh and then copied between environment hosts if you specify the remote host via an `ssh_uri` entry in the database.yml. This is helpful if the database host only allows connections from specific servers. If your `ssh_uri` optionally includes a path to your application root on the remote server, dbcp will load the database credentials from the remote server's config/database.yml.

Example config/database.yml:

```yaml
# Local database
development:
  adapter:  postgresql
  encoding: unicode
  pool: 5
  database: development_database
  username: development_username
  password: development_password

# Remote database, credentials provided locally, executed from remote host over ssh
staging:
  adapter:  postgresql
  database: staging_database
  username: staging_username
  password: staging_password
  ssh_uri:  ssh://deploy@staging.example.com

# Remote database, credentials fetched over ssh, executed from remote host over ssh
production:
  ssh_uri:  ssh://deploy@production.example.com/www/production.example.com/current
```

    $ dbcp staging development

### URI

You can use a database URI in place of an environment name as follows:

    $ dbcp postgres://my_username:my_pass@db.example.com/my_database development

### Capistrano v3

If you deploy your application via Capistrano, `dbcp` will lookup and invoke for a matching task name in your capistrano configuration to read the remote ssh and path information for the primary `:db` server role. It will ssh to that server both to read the remote remote `#{deploy_to}/current/config/database.yml` and execute the database export from.

Example, with `config/deploy/staging.rb`

```ruby
server 'staging.example.com', user: 'staging', roles: %w{web app db}
set :deploy_to, '/www/staging.example.com'
```

and separately defined `development` environment will allow you to run:

    $ cap staging development

## Roadmap

The following features are pending:

Providers:

- Heroku, environment name inferred from git remotes

Refactors:

- Handle pg_restore warnings
- Better logging
- Better help

Please [open an issue](https://github.com/gabetax/dbcp/issues) or send a pull request if you see a weird error, a database or environment definition you want supported, or anything you want to see improved.
