require "acquia_toolbelt"
require "acquia_toolbelt/error"
require "acquia_toolbelt/thor"

module AcquiaToolbelt
  class CLI < AcquiaToolbelt::Thor
    require "acquia_toolbelt/cli/ui"
    require "acquia_toolbelt/cli/api"
    require "acquia_toolbelt/auth"
    require "acquia_toolbelt/database"
    require "acquia_toolbelt/server"
    require "acquia_toolbelt/ssh"
    require "acquia_toolbelt/svn"
    require "acquia_toolbelt/task"
    require "acquia_toolbelt/site"
    require "acquia_toolbelt/domain"
    require "acquia_toolbelt/deploy"

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
    subcommand "auth", AcquiaToolbelt::Auth

    # Databases.
    desc "databases", "db sub commands"
    subcommand "databases", AcquiaToolbelt::CLI::Database

    # Servers.
    desc "servers", "server sub commands"
    subcommand "servers", AcquiaToolbelt::Server

    # SSH.
    desc "ssh", "ssh sub commands"
    subcommand "ssh", AcquiaToolbelt::SSH

    # SVN.
    desc "svn", "svn sub commands"
    subcommand "svn", AcquiaToolbelt::SVN

    # Tasks.
    desc "tasks", "tasks sub commands"
    subcommand "tasks", AcquiaToolbelt::Task

    # Sites.
    desc "sites", "sites sub commands"
    subcommand "sites", AcquiaToolbelt::Site

    # Domains.
    desc "domains", "domains sub commands"
    subcommand "domains", AcquiaToolbelt::CLI::Domain

    # Deployments.
    desc "deploy", "deploy sub commands"
    subcommand "deploy", AcquiaToolbelt::Deploy
  end
end