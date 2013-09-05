# Acquia Toolbelt

The Acquia Toolbelt is a Ruby wrapper and executable for using the Acquia
Cloud API. Some of the features include getting information around your servers,
subscription, databases, tasks and domains.

### Available commands

```
$ acquia
Commands:
  acquia help [COMMAND]                             # Describe available commands or one specific command
  acquia list-subscriptions                         # Find all subscriptions that you have access to.
  acquia login                                      # Login to your Acquia account.
  acquia view-environments <subscription>           # Provide an overview of the environments in your subscription.
  acquia view-servers <subscription> <environment>  # Get a list of servers specifications for an environment.
  acquia view-users <subscription>                  # Find out who has access and keys within your subscription.
```

###