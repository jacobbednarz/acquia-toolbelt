module AcquiaToolbelt
  class CLI
    class Servers < AcquiaToolbelt::Thor
      desc 'list', 'List all servers.'
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        environment = options[:environment]
        # Determine if we want just a single environment, or all of them at
        # once.
        if environment
          environments = [environment]
        else
          environments = AcquiaToolbelt::CLI::API.environments
        end

        # Loop over each environment and get all the associated server data.
        environments.each do |env|
          ui.say

          rows = []
          headings = [
            'FQDN',
            'Availability zone',
            'Type',
            'PHP processes',
            'Environment state',
            'Web state',
            'Varnish state',
            'External IP',
            'ELB domain'
          ]

          server_env = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/envs/#{env}/servers"
          server_env.each do |server|
            row_data = []
            row_data << server['fqdn']
            row_data << server['ec2_availability_zone']
            row_data << server['ami_type']

            # Show how many PHP processes this node can have. Note, this is only
            # available on the web servers.
            if server['services'] && server['services']['web']
              row_data << server['services']['web']['php_max_procs']
            else
              row_data << 'n/a'
            end

            if server['services'] && server['services']['web']
              row_data << server['services']['web']['env_status']
            else
              row_data << 'n/a'
            end

            if server['services'] && server['services']['web']
              row_data << server['services']['web']['status']
            else
              row_data << 'n/a'
            end

            # The state of varnish.
            if server['services'] && server['services']['varnish']
              # Replace underscores with a space to make the output slightly
              # nicer.
              row_data << server['services']['varnish']['status'].sub('_', ' ')
            else
              row_data << 'n/a'
            end

            # Only load balancers will have the 'external IP' property.
            if server['services'] && server['services']['external_ip']
              row_data << server['services']['external_ip']
            else
              row_data << 'n/a'
            end

            # Only load balancers will have the 'ELB domain name' property.
            if server['services'] && server['services']['elb_domain_name']
              row_data << server['services']['elb_domain_name']
            else
              row_data << 'n/a'
            end

            rows << row_data
          end

          ui.output_table("Environment: #{env}", headings, rows)
        end
      end
    end
  end
end
