module AcquiaToolbelt
  class CLI
    class SSH < AcquiaToolbelt::Thor
      # Public: List all SSH users.
      #
      # Returns a list of users and their SSH keys truncated.
      desc "list", "List all SSH users."
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        users = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/sshkeys"
        users.each do |user|
          say
          say "> ID: #{user["id"]}"
          say "> Name: #{user["nickname"]}"
          say "> Key: #{ AcquiaToolbelt::CLI::API.truncate_ssh_key user["ssh_pub_key"]}"
        end
      end

      desc "delete", "Delete a SSH key."
      method_option :id, :type => :string, :aliases => %w(-i), :required => true,
        :desc => "User ID to delete from SSH users."
      def delete
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        id = options[:id]

        delete_ssh_request = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/sshkeys/#{id}", "DELETE"
        ui.success "SSH key #{id} has been successfully deleted." if delete_ssh_request["id"]
      end
    end
  end
end