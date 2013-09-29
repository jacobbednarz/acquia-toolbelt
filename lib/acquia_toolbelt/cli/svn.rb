module AcquiaToolbelt
  class CLI
    class SVN < AcquiaToolbelt::Thor
      # Public: List all SVN users.
      #
      # Returns a list of available users.
      desc "list", "List all SVN users."
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        svn_users = AcquiaToolbelt::CLI::API.request  "sites/#{subscription}/svnusers"
        svn_users.each do |user|
          ui.say
          ui.say "> ID: #{user["id"]}"
          ui.say "> Name: #{user["username"]}"
        end
      end

      # Public: Create a new SVN user.
      #
      # Returns a status message.
      desc "add", "Add a SVN user."
      method_option :username, :type => :string, :aliases => %w(-u), :required => true,
        :desc => "Username you wish to set."
      method_option :password, :type => :string, :aliases => %w(-p), :required => true,
        :desc => "Password you wish to set."
      def add
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        username = options[:username]
        password = options[:password]

        add_svn_user = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/svnusers/#{username}", "POST", :password => "#{password}"
        ui.success "User '#{username}' has been successfully created." if add_svn_user["id"]
      end

      # Public: Delete a SVN user.
      #
      # Returns a status message.
      desc "delete", "Delete an SVN user."
      method_option :id, :type => :string, :aliases => %w(-i), :required => true,
        :desc => "User ID to delete from SVN users."
      def delete
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        userid = options[:id]

        svn_user_removal = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/svnusers/#{userid}", "DELETE"
        ui.success "#{userid} has been removed from the SVN users." if svn_user_removal["id"]
      end
    end
  end
end