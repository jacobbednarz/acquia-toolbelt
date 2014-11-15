module AcquiaToolbelt
  class CLI
    class Environments < AcquiaToolbelt::Thor
      # Public: List environments on a subscription.
      #
      # Output environment information.
      #
      # Returns enviroment data.
      desc 'list', 'List all environment data.'
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        environment = options[:environment]

        # If the environment option is set, just fetch a single environment.
        if environment
          environments = [environment]
        else
          environments = AcquiaToolbelt::CLI::API.environments
        end

        ui.say

        rows = []
        headings = [
          'Host',
          'Environment',
          'Current release',
          'Live development',
          'DB clusters',
          'Default domain'
        ]

        environments.each do |env|
          env_info = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{env}"
          row_data = []
          row_data << env_info['ssh_host']
          row_data << env_info['name']
          row_data << env_info['vcs_path']
          row_data << env_info['livedev'].capitalize
          row_data << env_info['db_clusters'].join(', ')
          row_data << env_info['default_domain']
          rows << row_data
        end

        ui.output_table('', headings, rows)
      end

      # Public: Toggle whether live development is enabled on an environment.
      #
      # Valid actions are enable or disable.
      #
      # Returns a status message.
      desc 'live-development', 'Enable/disbale live development on an environment.'
      method_option :action, :type => :string, :aliases => %w(-a),
        :required => true, :enum => ['enable', 'disable'],
        :desc => 'Status of live development (enable/disable).'

      def live_development
        if options[:environment].nil?
          ui.say "No value provided for required options '--environment'"
          return
        end

        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        action      = options[:action]
        environment = options[:environment]

        live_development_set = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/livedev/#{action}", 'POST'

        if live_development_set['id']
          ui.success "Live development has been successfully #{action}d on #{environment}."
        else
          ui.fail AcquiaToolbelt::CLI::API.display_error(live_development_set)
        end
      end
    end
  end
end
