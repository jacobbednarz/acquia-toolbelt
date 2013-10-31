module AcquiaToolbelt
  class CLI
    class Databases < AcquiaToolbelt::Thor
      no_tasks do
        # Internal: Build the database output.
        #
        # Output the database information exposing all the available fields and
        # data to the end user.
        #
        # Returns multiple lines.
        def output_database_instance(database)
          ui.say "> Username: #{database["username"]}"
          ui.say "> Password: #{database["password"]}"
          ui.say "> Host: #{database["host"]}"
          ui.say "> DB cluster: #{database["db_cluster"]}"
          ui.say "> Instance name: #{database["instance_name"]}"
        end
      end

      # Public: Add a database to the subscription.
      #
      # Returns a status message.
      desc "add", "Add a database."
      method_option :database, :type => :string, :aliases => %w(-d), :required => true,
        :desc => "Name of the database to create."
      def add
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        database     = options[:database]
        add_database = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/dbs", "POST", :db => "#{database}"
        ui.success "Database '#{database}' has been successfully created." if add_database["id"]
      end

      # Public: Copy a database from one environment to another.
      #
      # Returns a status message.
      desc "copy", "Copy a database from one environment to another."
      method_option :database, :type => :string, :aliases => %w(-d), :required => true,
        :desc => "Name of the database to copy."
      method_option :origin, :type => :string, :aliases => %w(-o), :required => true,
        :desc => "Origin of the database to copy."
      method_option :target, :type => :string, :aliases => %w(-t), :required => true,
        :desc => "Target of where to copy the database."
      def copy
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        database      = options[:database]
        origin        = options[:origin]
        target        = options[:target]
        copy_database = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/dbs/#{database}/db-copy/#{origin}/#{target}", "POST"
        ui.success "Database '#{database}' has been copied from #{origin} to #{target}." if copy_database["id"]
      end

      # Public: Delete a database from a subscription.
      #
      # NB: This will delete all instances of the database across all
      # environments.
      #
      # Returns a status message.
      desc "delete", "Delete a database."
      method_option :database, :type => :string, :aliases => %w(-d), :required => true,
        :desc => "Name of the database to delete."
      def delete
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        database  = options[:database]
        delete_db = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/dbs/#{database}", "DELETE"
        ui.success "Database '#{database}' has been successfully deleted." if delete_db["id"]
      end

      # Public: List all databases available within a subscription.
      #
      # Returns a database listing.
      desc "list", "List all databases."
      method_option :database, :type => :string, :aliases => %w(-d),
        :desc => "Name of the database to view."
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        database    = options[:database]
        environment = options[:environment]

        # Output a single database where the name and environment are specified.
        if database && environment
          database = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/dbs/#{database}"
          ui.say
          output_database_instance(database)

        # Only an environment was set so get all expanded data for the requested
        # environment.
        elsif environment
          databases = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/dbs"
          databases.each do |db|
            ui.say
            ui.say "#{db["name"]}"
            output_database_instance(db)
          end

        # Just a general listing of the databases, no in depth details.
        else
          databases = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/dbs"
          ui.say
          databases.each do |db|
            say "> #{db["name"]}"
          end
        end
      end

      # Public: Create a database instance backup.
      #
      # Returns a status message.
      desc "backup", "Create a new backup for a database."
      method_option :database, :type => :string, :aliases => %w(-d), :required => true,
        :desc => "Name of the database to backup."
      def backup
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        database      = options[:database]
        environment   = options[:environment]
        create_backup = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/dbs/#{database}/backups", "POST"
        ui.success "The backup for '#{database}' in #{environment} has been started." if create_backup["id"]
      end

      # Public: List available database backups.
      #
      # Returns all database backups.
      desc "list-backups", "List all database backups."
      method_option :database, :type => :string, :aliases => %w(-d), :required => true,
        :desc => "Name of the database to get the backup for."
      def list_backups
        # Ensure we have an environment defined.
        if options[:environment].nil?
          ui.say "No value provided for required options '--environment'"
          return
        end

        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        database    = options[:database]
        environment = options[:environment]
        backups     = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/dbs/#{database}/backups"
        backups.each do |backup|
          ui.say
          ui.say "> ID: #{backup["id"]}"
          ui.say "> MD5: #{backup["checksum"]}"
          ui.say "> Type: #{backup["type"]}"
          ui.say "> Path: #{backup["path"]}"
          ui.say "> Link: #{backup["link"]}"
          ui.say "> Started: #{Time.at(backup["started"].to_i)}"
          ui.say "> Completed: #{Time.at(backup["completed"].to_i)}"
        end
      end

      # Public: Restore a database backup.
      #
      # Returns a status message.
      desc "restore", "Restore a database from a backup."
      method_option :id, :type => :string, :aliases => %w(-i),
        :desc => "Backup ID to restore."
       method_option :database, :type => :string, :aliases => %w(-d),
        :desc => "Name of the database to restore."
      def restore
        # Ensure we have an environment defined.
        if options[:environment].nil?
          ui.say "No value provided for required options '--environment'"
          return
        end

        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        database    = options[:database]
        environment = options[:environment]
        database    = options[:database]
        backup_id   = options[:id]
        restore_db  = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/dbs/#{database}/backups/#{backup_id}/restore", "POST"
        ui.success "Database backup #{backup_id} has been restored to #{database} in #{environment}." if restore_db["id"]
      end
    end
  end
end