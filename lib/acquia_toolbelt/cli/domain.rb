module AcquiaToolbelt
  class CLI
    class Domain < AcquiaToolbelt::Thor
      no_tasks do
        # Internal: Purge a web cache for a domain.
        #
        # Returns a status message.
        def purge_domain(subscription, environment, domain)
          # Ensure all the required fields are available.
          if subscription.nil? || environment.nil? || domain.nil?
            ui.fail "Purge request is missing a required parameter."
            return
          end

          purge_request = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/domains/#{domain}/cache", "DELETE"
          ui.success "#{domain} has been successfully purged." if purge_request["id"]
        end
      end

      # Public: List all domains on a subscription.
      #
      # Returns all domains.
      desc "list", "List all domains."
      def list
        # Set the subscription if it has been passed through, otherwise use the
        # default.
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        # Get all the environments to loop over unless the environment is set.
        if options[:environment]
          environments = []
          environments << options[:environment]
        else
          environments = AcquiaToolbelt::CLI::API.get_environments
        end

        environments.each do |environment|
          domains = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/domains"
          ui.say
          ui.say "Environment: #{environment}" unless options[:environment]

          domains.each do |domain|
            ui.say "> #{domain["name"]}"
          end
        end
      end

      # Public: Add a domain to the subscription.
      #
      # Returns a status message.
      desc "add", "Add a domain."
      method_option :domain, :type => :string, :aliases => %w(-d), :required => true,
        :desc => "Full URL of the domain to add - No slashes or protocols required."
      def add
        if options[:environment].nil?
          ui.say "No value provided for required options '--environment'"
          return
        end

        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        environment  = options[:environment]
        domain       = options[:domain]
        add_domain   = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/domains/#{domain}", "POST"
        if add_domain["id"]
          ui.success "Domain #{domain} has been successfully added to #{environment}."
        else
          # The Acquia API does give back an error message however it is a
          # string inside of a JSON object so we have to re-do the string into a
          # JSON object to make it usuable.
          error = JSON.parse add_domain["message"]
          ui.fail "Oops, an error has occurred. Error message: #{error["message"]}"
        end
      end

      # Public: Delete a domain from an environment.
      #
      # Returns a status message.
      desc "delete", "Delete a domain."
      method_option :domain, :type => :string, :aliases => %w(-d), :required => true,
        :desc => "Full URL of the domain to add - No slashes or protocols required."
      def delete
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        environment   = options[:environment]
        domain        = options[:domain]
        delete_domain = AcquiaToolbelt::CLI::API.request "/sites/#{subscription}/envs/#{environment}/domains/#{domain}", "DELETE"
        ui.success "Domain #{domain} has been successfully deleted from #{environment}." if delete_domain["id"]
      end

      # Public: Purge a domains web cache.
      #
      # Returns a status message.
      desc "purge", "Purge a domain's web cache."
      method_option :domain, :type => :string, :aliases => %w(-d),
        :desc => "URL of the domain to purge."
      def purge
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        domain      = options[:domain]
        environment = options[:environment]

        # If the domain is not defined, we are going to clear a whole
        # environment. This can have severe performance impacts on your
        # environments. We need to be sure this is definitely what you want to
        # do.
        if domain
          purge_domain(subscription, environment, domain)
        else
          all_env_clear = ui.ask "You are about to clear all domains in the #{environment} environment. Are you sure? (y/n)"
          # Last chance to bail out.
          if all_env_clear == "y"
            domains = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/domains"
            domains.each do |domain|
              purge_domain("#{subscription}", "#{environment}", "#{domain["name"]}")
            end
          else
            ui.info "Ok, no action has been taken."
          end
        end
      end
    end
  end
end