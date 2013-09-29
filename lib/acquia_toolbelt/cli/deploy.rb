module AcquiaToolbelt
  class CLI
    class Deploy < AcquiaToolbelt::Thor
      desc "example", "example deploy command"
      def example
        puts "example deploy command"
      end
    end
  end
end