# Acquia Toolbelt 

The Acquia Toolbelt is a CLI tool for using the Acquia Cloud API. Some of the
features include getting information around your servers, subscription,
databases, tasks and domains.

## Installation

Installation is available (and recommended) via Ruby Gems.

```bash
$ gem install acquia_toolbelt
```

Once installed, the toolbelt is accessible via invoking `acquia` within the
command line.

## Usage
You can see all available commands by running `acquia help`. Additonally, more
information on each command is available via `acquia [COMMAND] help`.

```bash
$ acquia help

Type 'acquia [COMMAND] help' for more details on subcommands or to show example usage.

Commands:
  acquia auth
  acquia databases
  acquia deploy
  acquia domains
  acquia environments
  acquia files
  acquia servers
  acquia sites
  acquia ssh
  acquia svn
  acquia tasks

Options:
  -s, [--subscription=SUBSCRIPTION]  # Name of a subscription you would like to target.
  -e, [--environment=ENVIRONMENT]    # Environment to target for commands.
  -v, [--verbose]                    # Increase the verbose output from the commands.
```

#### Example commands

Without parameters:

```bash
$ acquia databases:list

> mydb
> mydb2
```

With parameters:

```bash
$ acquia databases:list -e dev -d mydb

> Username: exampledb
> Password: h5hKN4v2nc*1nd
> Host: staging-1234
> DB cluster: 1111
> Instance name: mydb8717
```

## Getting started

Before you can start using any commands, you need to first run
`acquia auth:login`. This will write your login details to a local netrc file so
that you won't be prompted for login details every time a request is made. After
that, the sky is the limit!

## FAQ

**Q: Is there support for proxies and corporate firewalls?**

**A:** By god yes. Proxies and corporate firewalls are the bane of my existence
so there was no way this toolbelt _wasn't_ going to support it. To use a proxy,
all you need to do is set your HTTPS_PROXY environment variable to the required
value. Example:

```bash
$ export HTTPS_PROXY="http://myproxy.url.internal:1234"
```

Then to check the value was correctly set:

```bash
$ echo $HTTPS_PROXY
$ http://myproxy.url.internal:1234
```

**Q: Is there somewhere I can see all the commands with required parameters?**

**A:** Yep. Check out the
[commands listing](https://github.com/jacobbednarz/acquia-toolbelt/wiki/Commands)
in the [wiki](https://github.com/jacobbednarz/acquia-toolbelt/wiki).

## Hacking on the Acquia Toolbelt

The Acquia Toolbelt uses [VCR](https://github.com/vcr/vcr) for recording and
replaying API fixtures during test runs - doing this allows the tests to stay
fast and easy for anyone to run.

Authenticated requests are currently using the user credentials from the netrc
file on your local system. It is a good idea to have this setup first (simply
by running `acquia auth:login`) as if you are recording new cassettes you will
need to be able to make actual requests. Don't worry about your user credentials
being stored in the fixtures as they are removed during the request and they
will appear as ACQUIA_USERNAME and ACQUIA_PASSWORD in the requests
respectively.

Since the cassettes are periodically refreshed to match changes to the API,
remember the keep the following in mind when making cassettes.

* **Specs should be idempotent.** The HTTP calls made during a spec should be
  able to be run over and over. This means deleting a known resource prior to
  creating it if the name has to be unique.
* **Specs should be able to be run in random order.** If a spec depends on
  another resource as a fixture, make sure that's created in the scope of the
  spec and not depend on a previous spec to create the data needed.
* **Do not depend on authenticated user info.** Instead of asserting actual
  values in resources, try to assert the existence of a key or that a response
  is an Array. We're testing the client, not the API.

### Running and writing new tests

The testing is mainly done via [RSpec](https://github.com/rspec/rspec). To run
the test suite, execute the `script/test` script in the root of the repository:

```bash
$ script/test
```

This will ensure all dependencies are installed and kick off the test suite.

### Supported versions

This library aims to support and is [tested against](https://travis-ci.org/jacobbednarz/acquia-toolbelt) the following Ruby implementations:

* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0

If you would like support for other implementations or versions, please open an
issue and it can be looked into.
