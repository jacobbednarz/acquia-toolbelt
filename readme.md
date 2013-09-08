# Acquia Toolbelt

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

You can see all available commands by running `acquia` without any commands or parameters. Additonally, more information on each command is available via `acquia help [COMMAND]`.

```
$ acquia

Commands:
  acquia add-database <subscription> <database>                          # Create a new database instance.
  acquia copy-database <subscription> <database> <source> <destination>  # Copy a database one from environment to another.
  acquia copy-files <subscription> <source> <destination>                # Copy files from one environment to another.
  acquia delete-database <subscription> <database>                       # Remove all instances of a database.
  acquia delete-svn-user <subscription> <userid>                         # Delete a SVN user.
  acquia help [COMMAND]                                                  # Describe available commands or one specific command
  acquia list-database-backups <subscription> <environment> <database>   # Get all backups for a database instance.
  acquia list-databases <subscription>                                   # See information about the databases within a subscription.
  acquia list-domains <subscription>                                     # Show all available domains for a subscription.
  acquia list-environments <subscription>                                # Provide an overview of the environments in your subscription.
  acquia list-servers <subscription>                                     # Get a list of servers specifications for an environment.
  acquia list-ssh-users <subscription>                                   # Find out who has access and SSH keys.
  acquia list-subscriptions                                              # Find all subscriptions that you have access to.
  acquia list-svn-users <subscription>                                   # See all the SVN users on a subscription.
  acquia login                                                           # Login to your Acquia account.
  acquia purge-domain <subscription>                                     # Clear the web cache of an environment or domain.
```

## Getting started

Before you can start using any commands, you need to first run `acquia login`. This will write your login details to a local netrc file so that you won't be prompted for login details every time a request is made. After that, the sky is the limit!

## FAQ

**Q:** Is there support for proxies and corporate firewalls?
**A:** By god yes. Proxies and corporate firewalls are the bane of my existence so there was no way this toolbelt _wasn't_ going to support it. To use a proxy, all you need to do is set your HTTPS_PROXY environment variable to the required value. Example:

```bash
$ export HTTPS_PROXY="http://myproxy.url.internal:1234"
```

Then to check the value was correctly set:

```bash
$ echo $HTTPS_PROXY
$ http://myproxy.url.internal:1234
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
