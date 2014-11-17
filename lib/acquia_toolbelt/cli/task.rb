module AcquiaToolbelt
  class CLI
    class Tasks < AcquiaToolbelt::Thor
      no_tasks do
        # Internal: Output information for a single task item.
        #
        # task - The task object that contains all the information about the
        #        task.
        def output_task_item(task)
          completion_time = (task['completed'].to_i - task['started'].to_i) / 60
          row_data = []
          description = task['description'].scan(/.{1,50}[\w\=]/).map(&:strip)

          row_data << task['id'].to_i
          row_data << task['queue']
          row_data << description.join("\n")
          row_data << task['state'].capitalize

          # If the completion time is greater then 0, output it in minutes
          # otherwise just say it was less then a minute.
          if completion_time > 0
            row_data << "About #{completion_time} minutes"
          else
            row_data << 'Less than 1 minute'
          end

          row_data
        end
      end

      # Public: List all tasks from the Acquia tasks queue(s).
      #
      # Returns a task listing.
      desc 'list', 'List all tasks.'
      method_option :queue, :type => :string, :aliases => %w(-q),
        :desc => 'Task queue to target.'
      method_option :count, :type => :string, :aliases => %w(-c),
        :desc => 'Limit the tasks returned.'
      def list
        if options[:subscription]
          subscription = options[:subscription]
        else
          subscription = AcquiaToolbelt::CLI::API.default_subscription
        end

        ui.say

        queue    = options[:queue]
        count    = options[:count]
        tasks    = []
        rows     = []
        headings = [
          'ID',
          'Queue',
          'Description',
          'State',
          'Completion time'
        ]

        all_tasks = AcquiaToolbelt::CLI::API.request "sites/#{subscription}/tasks"

        # Fetch a single queue from the tasks list if the queue parameter is set
        # otherwise just add all the tasks.
        if queue
          all_tasks.each do |task|
            tasks << task if task['queue'] == queue
          end
        else
          all_tasks.each do |task|
            tasks << task
          end
        end

        # If there is a count to return, restrict it to that required amount.
        tasks = tasks.last(count.to_i) if count && tasks.any?

        tasks.each do |task|
          rows << output_task_item(task)
        end

        ui.output_table('', headings, rows)
      end
    end
  end
end
