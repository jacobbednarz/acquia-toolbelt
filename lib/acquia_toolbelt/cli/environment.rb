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
    end
  end
end