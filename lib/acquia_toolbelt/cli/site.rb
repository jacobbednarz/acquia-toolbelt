module AcquiaToolbelt
  class CLI
    class Sites < AcquiaToolbelt::Thor
      # Public: List all subscriptions the user has access to.
      #
      # Returns a list of subscriptions.
      desc 'list', 'List all subscriptions you have access to.'
      def list
        sites = AcquiaToolbelt::CLI::API.request 'sites'

        sites.each do |site|
          ui.say
          # Get the individual subscription information.
          site_data = AcquiaToolbelt::CLI::API.request "sites/#{site}"

          ui.say "#{site_data['title']}"
          ui.say "> Username: #{site_data['unix_username']}"
          ui.say "> Subscription: #{site_data['name']}"

          # If the VCS type is SVN, we want it in all uppercase, otherwise just
          # capitilise it.
          if site_data['vcs_type'] == 'svn'
            vcs_name = site_data['vcs_type'].upcase
          else
            vcs_name = site_data['vcs_type'].capitalize
          end

          ui.say "> #{vcs_name} URL: #{site_data['vcs_url']}"
        end
      end
    end
  end
end
