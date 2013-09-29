module AcquiaToolbelt
  class CLI
    class SSH < AcquiaToolbelt::Thor
      desc "example", "example ssh command"
      def example
        puts "example ssh command"
      end
    end
  end
end