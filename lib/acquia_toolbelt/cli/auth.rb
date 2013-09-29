require "highline/import"
require "netrc"
require "acquia_toolbelt/cli"

module AcquiaToolbelt
  class CLI
    class Auth < AcquiaToolbelt::Thor
      desc "login", "Login to your Acquia account."
      # Public: Login to an Acquia account.
      #
      # Save the login details in a netrc file for use for all authenticated
      # requests.
      #
      # Returns a status message.
      def login
        cli = HighLine.new
        user = cli.ask("Enter your username: ")
        password = cli.ask("Enter your password: ") { |q| q.echo = false }

        # Update (or create if needed) the netrc file that will contain the user
        # authentication details.
        n = Netrc.read
        n.new_item_prefix = "# This entry was added for connecting to the Acquia Cloud API\n"
        n["cloudapi.acquia.com"] = user, password
        n.save

        ui.success "Your user credentials have been successfully set."
      end
    end
  end
end