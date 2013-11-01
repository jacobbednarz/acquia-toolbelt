# Acquia Toolbelt [![Gem Version](https://badge.fury.io/rb/acquia_toolbelt.png)](http://badge.fury.io/rb/acquia_toolbelt)

The Acquia Toolbelt is a CLI tool for using the Acquia Cloud API. Some of the
features include getting information around your servers, subscription,
databases, tasks and domains.

## Installation

Installation is available (and recommended) via Ruby Gems.

```
$ gem install acquia_toolbelt
```

Once installed, the toolbelt is accessible via invoking `acquia` within the command line.

## Usage
You can see all available commands by running `acquia help`. Additonally, more information on each command is available via `acquia [COMMAND] help`.

```
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

Without parameters

```
$ acquia database:list

> mydb
> mydb2
```

With parameters

```
$ acquia database:list -e dev -d mydb

> Username: exampledb
> Password: h5hKN4v2nc*1nd
> Host: staging-1234
> DB cluster: 1111
> Instance name: mydb8717
```

## Getting started

Before you can start using any commands, you need to first run `acquia auth:login`. This will write your login details to a local netrc file so that you won't be prompted for login details every time a request is made. After that, the sky is the limit!

## FAQ

**Q: Is there support for proxies and corporate firewalls?**

**A:** By god yes. Proxies and corporate firewalls are the bane of my existence so there was no way this toolbelt _wasn't_ going to support it. To use a proxy, all you need to do is set your HTTPS_PROXY environment variable to the required value. Example:

```bash
$ export HTTPS_PROXY="http://myproxy.url.internal:1234"
```

Then to check the value was correctly set:

```bash
$ echo $HTTPS_PROXY
$ http://myproxy.url.internal:1234
```

**Q: Is there somewhere I can see all the commands with required parameters?**

**A:** Yep. Check out the [commands listing](https://github.com/jacobbednarz/acquia-toolbelt/wiki/Commands) in the [wiki](https://github.com/jacobbednarz/acquia-toolbelt/wiki).

## Running tests

```
bundle exec ruby spec_helper.rb
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
