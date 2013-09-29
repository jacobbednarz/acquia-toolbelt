module AcquiaToolbelt
  class CLI
    class Files < AcquiaToolbelt::Thor
      desc "example", "example file command"
      def example
        puts "example file command"
      end
    end
  end
end