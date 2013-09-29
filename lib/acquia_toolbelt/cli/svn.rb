module AcquiaToolbelt
  class CLI
    class SVN < AcquiaToolbelt::Thor
      desc "example", "example SVN command"
      def example
        puts "example SVN command"
      end
    end
  end
end