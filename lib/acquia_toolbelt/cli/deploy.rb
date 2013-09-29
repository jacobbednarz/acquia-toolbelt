module AcquiaToolbelt
  class CLI
    class Deploy < AcquiaToolbelt::Thor
      desc "code", "Deploy a VCS branch or tag to an environment."
      method_option :release, :type => :string, :aliases => %w(-r), :required => true,
        :desc => "Name of the release to deploy to the environment."
      def code
        if options[:environment].nil?
          ui.say "No value provided for required options '--environment'"
          return
        end

        subscription = options[:subscription] ? options[:subscription] : AcquiaToolbelt::CLI::API.default_subscription
        environment  = options[:environment]
        release      = options[:release]

        deploy_code =  AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/code-deploy", "CODE-DEPLOY-POST", :release => "#{release}"
        ui.success "#{release} has been deployed to #{environment}." if deploy_code["id"]
      end
    end
  end
end