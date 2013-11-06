module AcquiaToolbelt
  class CLI
    class Environments < AcquiaToolbelt::Thor
      # Public: List environments on a subscription.
      #
      # Output environment information.
      #
      # Returns enviroment data.
      desc "list", "List all environment data."
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
          environments = AcquiaToolbelt::CLI::API.get_environments
        end

        environments.each do |environment|
          env_info = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}"
          ui.say
          ui.say "> Host: #{env_info["ssh_host"]}"
          ui.say "> Environment: #{env_info["name"]}"
          ui.say "> Current release: #{env_info["vcs_path"]}"
          ui.say "> DB clusters: #{env_info["db_clusters"].to_s unless env_info["db_clusters"].nil?}"
          ui.say "> Default domain: #{env_info["default_domain"]}"
        end
      end

      # Public: Toggle whether live development is enabled on an environment.
      #
      # Valid actions are enable or disable.
      #
      # Returns a status message.
      desc "live-development", "Enable/disbale live development on an environment."
      method_option :action, :type => :string, :aliases => %w(-a), :required => true,
        :desc => "Status of live development (enable/disable).",
        :enum => ["enable", "disable"]
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

        live_development_set = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/livedev/#{action}", "POST"

        if live_development_set["id"]
          ui.success "Live development has been successfully #{action}d on #{environment}."
        else
          ui.fail AcquiaToolbelt::CLI::API.display_error(live_development_set)
        end
      end
    end
  end
end
