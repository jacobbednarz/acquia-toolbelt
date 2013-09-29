module AcquiaToolbelt
  class CLI
    class Server < AcquiaToolbelt::Thor
      desc "example", "example server command"
      def example
        puts "example server command"
      end
    end
  end
end