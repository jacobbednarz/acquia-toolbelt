module AcquiaToolbelt
  class CLI
    class Site < AcquiaToolbelt::Thor
      # Public: List all subscriptions the user has access to.
      #
      # Returns a list of subscriptions.
      desc "list", "List all subscriptions you have access to."
      def list
        sites = AcquiaToolbelt::CLI::API.request "sites"

        sites.each do |site|
          ui.say
          # Get the individual subscription information.
          site = AcquiaToolbelt::CLI::API.request "sites/#{site}"

          ui.say "#{site["title"]}"
          ui.say "> Username: #{site["unix_username"]}"
          ui.say "> Subscription: #{site["name"]}"

          # If the VCS type is SVN, we want it in all uppercase, otherwise just
          # capitilise it.
          vcs_name = (site["vcs_type"] == "svn") ? site["vcs_type"].upcase : site["vcs_type"].capitalize
          ui.say "> #{vcs_name} URL: #{site["vcs_url"]}"
        end
      end
    end
  end
end