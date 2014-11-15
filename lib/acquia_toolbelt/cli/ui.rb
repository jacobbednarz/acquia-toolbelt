require 'highline/import'
require 'rainbow'

module AcquiaToolbelt
  class CLI
    class UI < Thor::Base.shell
      # Internal: Used for outputting a pretty success message.
      #
      # text - The text to run through and output to the end user.
      #
      # Returns the string coloured and formatted.
      def success(text)
        puts "#{text}".foreground(:green)
      end

      # Internal: Used for outputting a pretty error message.
      #
      # text - The text to run through and output to the end user.
      #
      # Returns the string coloured and formatted.
      def fail(text)
        puts "#{text}".foreground(:red)
      end

      # Internal: Used for outputting a pretty info message.
      #
      # text - The text to run through and output to the end user.
      #
      # Returns the string coloured and formatted.
      def info(text)
        puts "#{text}".foreground(:cyan)
      end

      # Internal: Used for outputting a pretty debug message.
      #
      # text - The text to run through and output to the end user.
      #
      # Returns the string coloured and formatted.
      def debug(text)
        puts "#{text}".foreground(:yellow)
      end

      # Internal: Render a CLI table.
      #
      # title   - The title to display at the top of the table.
      # heading - Header rows for the table.
      # rows    - An array of the row data to output.
      #
      # Outputs a table to the end user.
      def output_table(title = '', headings, rows)
        table = Terminal::Table.new
        table.title = title unless title.empty?
        table.rows = rows
        table.headings = headings
        table.style = {
          :padding_left  => 1,
          :padding_right => 1,
        }

        puts table
      end
    end
  end
end
