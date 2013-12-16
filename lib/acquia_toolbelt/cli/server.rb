module AcquiaToolbelt
  class CLI
    class Servers < AcquiaToolbelt::Thor
      desc "list", "List all servers."
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        environment = options[:environment]
        # Determine if we want just a single environment, or all of them at once.
        if environment
          environments = [environment]
        else
          environments = AcquiaToolbelt::CLI::API.get_environments
        end

        # Loop over each environment and get all the associated server data.
        environments.each do |environment|
          ui.say
          ui.say "Environment: #{environment}"

          server_env = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{environment}/servers"
          server_env.each do |server|
            ui.say
            ui.say "> Host: #{server["fqdn"]}"
            ui.say "> Region: #{server["ec2_region"]}"
            ui.say "> Instance type: #{server["ami_type"]}"
            ui.say "> Availability zone: #{server["ec2_availability_zone"]}"

            # Show how many PHP processes this node can have. Note, this is only
            # available on the web servers.
            if server["services"] && server["services"]["php_max_procs"]
              ui.say "> PHP max processes: #{server["services"]["php_max_procs"]}"
            end

            if server["services"] && server["services"]["status"]
              ui.say "> Status: #{server["services"]["status"]}"
            end

            if server["services"] && server["services"]["web"]
              ui.say "> Web status: #{server["services"]["web"]["status"]}"
            end

            # The state of varnish.
            if server["services"] && server["services"]["varnish"]
              ui.say "> Varnish status: #{server["services"]["varnish"]["status"]}"
            end

            # Only load balancers will have the "external IP" property.
            if server["services"] && server["services"]["external_ip"]
              ui.say "> External IP: #{server["services"]["external_ip"]}"
            end

            # If running a dedicated load balancer, there will be a ELB domain
            # associated with the load balancing tier.
            if server["services"] && server["services"]["elb_domain_name"]
              ui.say "> ELB hostname: #{server["services"]["elb_domain_name"]}"
            end
          end
        end
      end
    end
  end
end