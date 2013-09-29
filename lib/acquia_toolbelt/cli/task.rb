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

      desc "example", "example task command"
      def example
        puts "example task command"
      end
    end
  end
end