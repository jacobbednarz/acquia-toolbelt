module AcquiaToolbelt
  class CLI
    class Files < AcquiaToolbelt::Thor
      # Public: Copy files from one environment to another.
      #
      # Returns a status message from the task.
      desc 'copy', 'Copy files from one environment to another.'
       method_option :origin, :type => :string, :aliases => %w(-o),
        :required => true, :desc => 'Source environment for the file copy.'
      method_option :target, :type => :string, :aliases => %w(-t),
        :required => true, :desc => 'Target environment for the file copy.'
      def copy
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        source    = options[:origin]
        target    = options[:target]
        file_copy = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/files-copy/#{source}/#{target}", "POST"

        if file_copy['id']
          ui.success "File copy from #{source} to #{target} has started."
        else
          ui.fail AcquiaToolbelt::CLI::API.display_error(file_copy)
        end
      end
    end
  end
end
