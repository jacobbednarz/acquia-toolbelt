require "acquia_toolbelt"
require "acquia_toolbelt/error"
require "acquia_toolbelt/thor"

module AcquiaToolbelt
  class CLI < AcquiaToolbelt::Thor
    require "acquia_toolbelt/cli/ui"
    require "acquia_toolbelt/cli/api"
    require "acquia_toolbelt/cli/auth"
    require "acquia_toolbelt/cli/database"
    require "acquia_toolbelt/cli/server"
    require "acquia_toolbelt/cli/ssh"
    require "acquia_toolbelt/cli/svn"
    require "acquia_toolbelt/cli/task"
    require "acquia_toolbelt/cli/site"
    require "acquia_toolbelt/cli/domain"
    require "acquia_toolbelt/cli/deploy"
    require "acquia_toolbelt/cli/file"
    require "acquia_toolbelt/cli/user"
    require "acquia_toolbelt/cli/environment"

    include Thor::Actions

    def self.start(given_args = ARGV, config = {})
      Thor::Base.shell = AcquiaToolbelt::CLI::UI
      ui = AcquiaToolbelt::CLI::UI.new
      super(given_args, {:shell => ui}.merge(config))
    rescue AcquiaToolbelt::Error
      ui.print_exception(e)
      raise
    rescue Interrupt => e
      puts
      ui.print_exception(e)
      ui.say("Quitting...")
      raise
    rescue SystemExit, Errno::EPIPE
      # Don't print a message for safe exits
      raise
    rescue Exception => e
      ui.print_exception(e)
      raise
    end

    # Define some options that are available to all commands.
    class_option :subscription, :type => :string, :aliases => %w(-s),
      :desc => "Name of a subscription you would like to target."
    class_option :environment, :type => :string, :aliases => %w(-e),
      :desc => "Environment to target for commands."
    class_option :verbose, :type => :boolean, :aliases => %w(-v),
      :desc => "Increase the verbose output from the commands."

    # Authentication.
    desc "auth", "auth sub commands"
    subcommand "auth", AcquiaToolbelt::CLI::Auth

    # Databases.
    desc "databases", "db sub commands"
    subcommand "databases", AcquiaToolbelt::CLI::Database

    # Servers.
    desc "servers", "server sub commands"
    subcommand "servers", AcquiaToolbelt::CLI::Server

    # SSH.
    desc "ssh", "ssh sub commands"
    subcommand "ssh", AcquiaToolbelt::CLI::SSH

    # SVN.
    desc "svn", "svn sub commands"
    subcommand "svn", AcquiaToolbelt::CLI::SVN

    # Tasks.
    desc "tasks", "tasks sub commands"
    subcommand "tasks", AcquiaToolbelt::CLI::Task

    # Sites.
    desc "sites", "sites sub commands"
    subcommand "sites", AcquiaToolbelt::CLI::Site

    # Domains.
    desc "domains", "domains sub commands"
    subcommand "domains", AcquiaToolbelt::CLI::Domain

    # Deployments.
    desc "deploy", "deploy sub commands"
    subcommand "deploy", AcquiaToolbelt::CLI::Deploy

    # Files.
    desc "files", "files sub commands"
    subcommand "files", AcquiaToolbelt::CLI::Files

    # Users.
    desc "users", "users sub commands"
    subcommand "users", AcquiaToolbelt::CLI::Users

    # Environments.
    desc "environments", "environments sub commands"
    subcommand "environments", AcquiaToolbelt::CLI::Environment
  end
end