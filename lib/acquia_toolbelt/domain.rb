module AcquiaToolbelt
  class CLI
    class Domain < AcquiaToolbelt::Thor
      desc "list", "List all domains."
      def list
        # Set the subscription if it has been passed through, otherwise use the
        # default.
        if options[:subscription]
          site = options[:subscription]
        else
          site = AcquiaToolbelt::CLI::API.default_subscription
        end

        # Get all the environments to loop over unless the environment is set.
        if options[:environment]
          environments = []
          environments << options[:environment]
        else
          environments = AcquiaToolbelt::CLI::API.get_environments
        end

        environments.each do |environment|
          domains = AcquiaToolbelt::CLI::API.request "sites/#{site}/envs/#{environment}/domains"
          ui.say
          ui.say "Environment: #{environment}" unless options[:environment]

          domains.each do |domain|
            ui.say "> #{domain["name"]}"
          end
        end
      end
    end
  end
end