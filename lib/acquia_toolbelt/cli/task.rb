module AcquiaToolbelt
  class CLI
    class Task < AcquiaToolbelt::Thor
      no_tasks do
        # Internal: Output information for a single task item.
        def output_task_item(task)
          completion_time = (task["completed"].to_i - task["started"].to_i) / 60
          ui.say
          ui.say "Task ID: #{task["id"].to_i}"
          ui.say "Description: #{task["description"]}"
          ui.say "Status: #{task["state"]}"

          # If the completion time is greater then 0, output it in minutes otherwise
          # just say it was less then a minute.
          if completion_time > 0
            ui.say "Compeletion time: About #{completion_time} minutes"
          else
            ui.say "Compeletion time: Less than 1 minute"
          end

          ui.say "Queue: #{task["queue"]}"
        end
      end

      # Public: List all tasks.
      #
      # Returns a task listing.
      desc "list", "List all tasks."
      method_option :queue, :type => :string, :aliases => %w(-q),
        :desc => "Task queue to target."
      method_option :count, :type => :string, :aliases => %w(-c),
        :desc => "Limit the tasks returned."
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        queue = options[:queue]
        count = options[:count]

        all_tasks = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/tasks"
        tasks = []

        # Fetch a single queue from the tasks list if the queue parameter is set
        # otherwise just add all the tasks.
        if queue
          all_tasks.each do |task|
            if task["queue"] == queue
              tasks << task
            end
          end
        else
          all_tasks.each do |task|
            tasks << task
          end
        end

        # If there is a count to return, restrict it to that required amount.
        if count && tasks.any?
          tasks = tasks.last(count.to_i)
        end

        tasks.each do |task|
          output_task_item(task)
        end
      end
    end
  end
end