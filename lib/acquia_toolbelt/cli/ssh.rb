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

      # Public: Delete a SSH key.
      #
      # Returns a status message.
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

      # Public: Add a SSH key to a subscription.
      #
      # Returns a status message.
      desc "add", "Add a SSH key."
      method_option :nickname, :type => :string, :aliases => %w(-n), :required => true,
        :desc => "Nickname to ."
      method_option :key, :type => :string, :aliases => %w(-k), :required => true,
        :desc => "Public SSH key to add."
      def add
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        key      = options[:key]
        nickname = options[:nickname]
        data     = { :key => "nickname", :value => "#{nickname}", :ssh_pub_key => "#{key}" }

        add_ssh_key = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/sshkeys", "QUERY-STRING-POST", data
        ui.success "SSH key '#{nickname}' has been successfully added." if add_ssh_key["id"]
      end
    end
  end
end