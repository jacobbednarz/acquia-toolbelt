$:.unshift(File.expand_path('../vendor/thor/lib/', File.dirname(__FILE__)))
require 'thor'

module AcquiaToolbelt
   module UtilityMethods
    protected

    # Alias Thor's shell to UI instead.
    def ui
      shell
    end
  end

  class Thor < ::Thor
    include UtilityMethods
    no_tasks do
      def self.help(shell, subcommand = false)
        list = printable_commands(true, subcommand).sort!{ |a,b| a[0] <=> b[0] }

        shell.say "Type 'acquia [COMMAND] help' for more details on subcommands or to show example usage."

        if @package_name
          shell.say "#{@package_name} commands:"
        else
          shell.say
          shell.say "Commands:"
        end

        shell.print_table(list, :indent => 2, :truncate => true)
        shell.say unless subcommand
        class_options_help(shell)
      end

      def self.printable_commands(all = true, subcommand = true)
        (all ? all_commands : commands).map do |_, command|
          # Don't show the hidden commands or the help commands.
          next if command.hidden? || next if command.name.include? 'help'
          item = []
          item << banner(command, false, subcommand)
          item << (command.description ? "# #{command.description.gsub(/\s+/m,' ')}" : "") unless command.description.empty?
          item
        end.compact
      end

      # Define a base for the commands.
      def self.banner_base
        "acquia"
      end

      def self.banner(task, task_help = false, subcommand = false)
        subcommand_banner = to_s.split(/::/).map{|s| s.downcase}[2..-1]
        subcommand_banner = if subcommand_banner.size > 0
                              subcommand_banner.join(" ")
                            else
                              nil
                            end

        task = (task_help ? task.formatted_usage(self, false, subcommand) : task.name)
        banner_base + " " + [subcommand_banner, task].compact.join(":")
      end

      def self.handle_no_task_error(task)
        raise UndefinedTaskError, "Could not find command #{task.inspect}."
      end

      def self.subcommand(name, klass)
        @@subcommand_class_for ||= {}
        @@subcommand_class_for[name] = klass
        super
      end

      def self.subcommand_class_for(name)
        @@subcommand_class_for ||= {}
        @@subcommand_class_for[name]
      end

    end

    protected

    def self.exit_on_failure?
      true
    end
  end

  # Patch handle_no_method_error? to work with rubinius' error text.
  class ::Thor::Task
    def handle_no_method_error?(instance, error, caller)
      not_debugging?(instance) && (
        error.message =~ /^undefined method `#{name}' for #{Regexp.escape(instance.to_s)}$/ ||
        error.message =~ /undefined method `#{name}' on an instance of #{Regexp.escape(instance.class.name)}/
      )
    end
  end
end