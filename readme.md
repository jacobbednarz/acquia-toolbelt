# Acquia Toolbelt

The Acquia Toolbelt is a Ruby wrapper and executable for using the Acquia
Cloud API. Some of the features include getting information around your servers,
subscription, databases, tasks and domains.

## Available commands

```
$ acquia
Commands:
  acquia help [COMMAND]                    # Describe available commands or one specific command
  acquia list-environments <subscription>  # Provide an overview of the environments in your subscription.
  acquia list-servers <subscription>       # Get a list of servers specifications for an environment.
  acquia list-subscriptions                # Find all subscriptions that you have access to.
  acquia list-users <subscription>         # Find out who has access and keys within your subscription.
  acquia login                             # Login to your Acquia account.
```

## Usage examples

### list-environments

Provide an overview of the environments in your subscription.

**Command:**
```
acquia list-environments <subscription>
```

**Usage:**
```
$ acquia list-environments subscription-1

> Host: env-1234.prod.hosting.acquia.com
> Environment: dev
> Current release: tags/1.0
> DB clusters: ["1150"]
> Default domain: mysitedev.prod.acquia-sites.com

> Host: env-1235.prod.hosting.acquia.com
> Environment: stage
> Current release: tags/1.2
> DB clusters: ["1151"]
> Default domain: mysitestg.prod.acquia-sites.com

> Host: env-1236.prod.hosting.acquia.com
> Environment: prod
> Current release: tags/master
> DB clusters: ["1152"]
> Default domain: mysiteprod.prod.acquia-sites.com
```

### list-servers

Get a list of servers specifications for an environment.

**Command:**
```
acquia list-servers <subscription> <environment>
```

**Usage:**
```
$ acquia list-environments subscription-1 dev

> Host: bal-1234.prod.hosting.acquia.com
> EC2 region: us-east-1
> Availability zone: us-east-1e
> EC2 instance type: m1.large
> Varnish status: hot_spare

> Host: bal-1234.prod.hosting.acquia.com
> EC2 region: us-east-1
> Availability zone: us-east-1c
> EC2 instance type: m1.large
> Varnish status: active
> External IP: 123.123.123.123

> Host: env-1235.prod.hosting.acquia.com
> EC2 region: us-east-1
> Availability zone: us-east-1e
> EC2 instance type: m2.xlarge
> Web status: online

> Host: svn-1111.prod.hosting.acquia.com
> EC2 region: us-east-1
> Availability zone: us-east-1d
> EC2 instance type: c1.xlarge
```

### list-subscriptions

Find all subscriptions that you have access to.

**Command:**
```
acquia list-subscriptions
```

**Usage:**
```
$ acquia list-subscriptions

My Test Dev Cloud
> Username: testdevcloud
> Subscription: subscription-1
> Git URL: user@svn-1111.prod.hosting.acquia.com:repo.git
```

### list-users

Find out who has access and keys within your subscription.

**Command:**
```
acquia list-users
```

**Usage:**
```
$ acquia list-users subscription-1

> Name: my-home-machine (12345)
> Key: ssh-rsa AAAAB358587C1yc2EAAAADAQ...kJ97239OqYu+kR1HSMYH me@example.com
```