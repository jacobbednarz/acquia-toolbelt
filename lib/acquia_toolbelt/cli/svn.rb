module AcquiaToolbelt
  class CLI
    class SVN < AcquiaToolbelt::Thor
      # Public: List all SVN users.
      #
      # Returns a list of available users.
      desc 'list', 'List all SVN users.'
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        ui.say

        rows = []
        headings = [
          'ID',
          'Name'
        ]

        svn_users = AcquiaToolbelt::CLI::API.request  "sites/#{subscription}/svnusers"
        svn_users.each do |user|
          row_data = []
          row_data << user['id']
          row_data << user['username']
          rows << row_data
        end

        ui.output_table('', headings, rows)
      end

      # Public: Create a new SVN user.
      #
      # Returns a status message.
      desc 'add', 'Add a SVN user.'
      method_option :username, :type => :string, :aliases => %w(-u),
        :required => true, :desc => "Username you wish to set."
      method_option :password, :type => :string, :aliases => %w(-p),
        :required => true, :desc => "Password you wish to set."
      def add
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        username = options[:username]
        password = options[:password]

        add_svn_user = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/svnusers/#{username}", 'POST', :password => "#{password}"
        if add_svn_user['id']
          ui.success "User '#{username}' has been successfully created."
        else
          ui.fail AcquiaToolbelt::CLI::API.display_error(add_svn_user)
        end
      end

      # Public: Delete a SVN user.
      #
      # Returns a status message.
      desc 'delete', 'Delete an SVN user.'
      method_option :id, :type => :string, :aliases => %w(-i),
        :required => true, :desc => 'User ID to delete from SVN users.'
      def delete
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        userid = options[:id]

        svn_user_removal = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/svnusers/#{userid}", 'DELETE'
        if svn_user_removal['id']
          ui.success "#{userid} has been removed from the SVN users."
        else
          ui.fail AcquiaToolbelt::CLI::API.display_error(svn_user_removal)
        end
      end
    end
  end
end
