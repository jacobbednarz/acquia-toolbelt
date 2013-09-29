module AcquiaToolbelt
  class CLI
    class Users < AcquiaToolbelt::Thor
      desc "example", "example user command"
      def example
        puts "example user command"
      end
    end
  end
end