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
      def self.subcommand_help(cmd)
        desc "#{cmd} help [COMMAND]", "Describe all subcommands or one specific subcommand."
        class_eval <<-RUBY
          def help(*args)
            if args.empty?
              ui.say "usage: #{banner_base} #{cmd} COMMAND"
              ui.say
              subcommands = self.class.printable_tasks.sort_by{|s| s[0] }
              subcommands.reject!{|t| t[0] =~ /#{cmd} help$/}
              ui.print_help(subcommands)
              ui.say self.class.send(:class_options_help, ui)
              ui.say "See #{banner_base} #{cmd} help COMMAND" +
                " for more information on a specific subcommand." if args.empty?
            else
              super
            end
          end
        RUBY
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
        [banner_base, subcommand_banner, task].compact.join(" ")
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