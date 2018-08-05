# Security Hackathon 

This app is a vulnerable version of Rails 5. It includes vulnerabilities from the OWASP Top 10, as well as some "extras".

## Getting Started

To begin, if you don't have Rails, Ruby, Git and sqlite3 use
this [site](https://gorails.com/setup) to install the software.
Pick the appropriate operating system and follow the instructions.

After installing the above software, clone this repo:

```bash
$ git clone git@github.com:unboxed/security-hackathon.git
```

Navigate into the directory and install the dependencies:

```bash
$ bundle install
```

If you receive an error, make sure you have `bundler` installed:

```bash
$ gem install bundler
```

Initialize the database:

```bash
$ bundle exec rails db:setup
```

Start the web server:

```bash
$ bundle exec rails server
```

Open your favorite browser and navigate to `http://localhost:3000`

Start looking for vulnerabilities! 

Happy Hacking!

## Docker Install

To run the app with Docker you must first have [Docker](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/) installed. Once those dependencies are installed, cd into the app directory where you've cloned the code and run. Rails requires Compose **1.6.0** or above and require a Docker Engine of version **1.10.0** or above.

```
#~/security-hackathon
$ docker-compose build
$ docker-compose run web rails db:setup
$ docker-compose up
...
  Creating security-hackathon_web_1
  Attaching to security-hackathon_web_1
$
```
Once you see the preceeding message, the app is running on your localhost on port 1337.

Open your favorite browser, navigate to `http://localhost:1337/` and start hacking! Run `docker-compose ps` to verify.

Note: if your container exits with an error, it may be because a server is already running:
```
A server is already running. Check /myapp/tmp/pids/server.pid.
=> Booting Thin
=> Rails 5.0.1 application starting in development on
http://0.0.0.0:1337
=> Run `rails server -h` for more startup options
=> Ctrl-C to shutdown server
Exiting
```
In this case, remove that server.pid file and try again. Note also that this file is in your current working directory, not inside the container.

## Capybara Tests

This app includes a set of failing Capybara tests (specs), each one indicating that a separate vulnerability exists in the application. To run them, you first need to install [PhantomJS](https://github.com/jonleighton/poltergeist#installing-phantomjs) which is required by the Poltergeist Capybara driver. Upon installation, simply run the following task:

```
$ bundle exec rspec
```

To run just one spec:

```
$ bundle exec rspec spec/vulnerabilities/sql_injection_spec.rb
```

## Processing Email

In order for the app to effectively process email, you will first need to run MailCatcher, an SMTP server that will intercept email messages and display them in a web interface.

Mailcatcher is not installed by default. To install MailCatcher and start an instance of it, simply run:

```
$ gem install mailcatcher
$ mailcatcher
```

If successful, you should see the following output:

```
Starting MailCatcher
==> smtp://127.0.0.1:1025
==> http://127.0.0.1:1080
*** MailCatcher runs as a daemon by default. Go to the web interface to quit.
```

Alternatively, you can run MailCatcher in the foreground by running `mailcatcher -f` in your terminal.

# License

[The MIT License (MIT)](./LICENSE.md)
