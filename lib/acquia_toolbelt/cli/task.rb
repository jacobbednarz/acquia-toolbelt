module AcquiaToolbelt
  class CLI
    class Task < AcquiaToolbelt::Thor
      desc "example", "example task command"
      def example
        puts "example task command"
      end
    end
  end
end