require "highline/import"
require "rainbow"

module AcquiaToolbelt
  class CLI
    class UI < Thor::Base.shell
      # Internal: Used for outputting a pretty success message.
      #
      # Returns the string coloured and formatted.
      def success(text)
        puts "#{text}".foreground(:green)
      end

      # Internal: Used for outputting a pretty error message.
      #
      # Returns the string coloured and formatted.
      def fail(text)
        puts "#{text}".foreground(:red)
      end

      # Internal: Used for outputting a pretty info message.
      #
      # Returns the string coloured and formatted.
      def info(text)
        puts "#{text}".foreground(:cyan)
      end
    end
  end
end
