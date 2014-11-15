module AcquiaToolbelt
  class CLI
    class Sites < AcquiaToolbelt::Thor
      # Public: List all subscriptions the user has access to.
      #
      # Returns a list of subscriptions.
      desc 'list', 'List all subscriptions you have access to.'
      def list
        sites = AcquiaToolbelt::CLI::API.request 'sites'
        ui.say

        rows = []
        headings = [
          'Subscription name',
          'Unix username',
          'Realm name',
          'UUID',
          'Production mode'
        ]

        sites.each do |site|
          # Get the individual subscription information.
          site_data = AcquiaToolbelt::CLI::API.request "sites/#{site}"

          row_data = []
          row_data << site_data['title']
          row_data << site_data['unix_username']
          row_data << site_data['name']
          row_data << site_data['uuid']
          row_data << site_data['production_mode']
          rows << row_data
        end

        ui.output_table('', headings, rows)
      end
    end
  end
end
