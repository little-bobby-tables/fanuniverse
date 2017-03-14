# Fan Universe

A repository for [Fan Universe](https://www.fanuniverse.org) application code.

## Contributing

Follow this instructions to get the application up and running
on your local machine for development and testing.

### Prerequisites

Install the following dependencies
(packages in parentheses are specified for RPM-based distributions):

* Java 8+ (`java-1.8.0-openjdk`)
* [Elasticsearch 5](https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html)
* [PostgreSQL 9.6](https://www.postgresql.org/download/linux/redhat/#yum)
* ImageMagick (`ImageMagick`)
* Node.js (`nodejs`)
* [Yarn](https://yarnpkg.com/en/docs/install)

You'll also need a Ruby version manager
(such as [chruby](https://github.com/postmodern/chruby)) with Ruby 2.4.0 installed.

### Running the application

`bin/setup` prepares the environment (installs gem dependencies and
creates the database). You only need to run this once.

`bin/gulp` tracks changes to JS and CSS files and automatically recompiles the assets.

`puma` boots the application server on port 3000.

`sidekiq` processes background jobs.

`rails test` runs the test suite.
