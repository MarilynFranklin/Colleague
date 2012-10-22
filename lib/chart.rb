module Shoes::Types

  def open_chart_window(project)
    @window = window :title => project.title, :width => 1250 do
      dependent_tasks = project.checklist.projects.select{ |task| task.dependent_task }
      dependent_tasks.sort_by!{ |task| task.start_time }
        final_one = dependent_tasks.last.dependent_task
      main_content = flow do
      flow do
        para "  #{dependent_tasks[0].start_time.year}"
      end

      flow do
        date = dependent_tasks[0].start_time
        para "  "
        15.times do
          para "|   #{date.strftime("%m - %d")}   "
          date = date + DAY
        end
        para "|"
      end
      stack do
        margin = 18
        dependent_tasks.each do |task|
          flow :margin_left => margin do 
            background palegreen, :width => (task.time_estimate * 81)
            para "#{task.title}"
            margin += (task.time_estimate * 81) if task.time_estimate
          end
        end
        final_one = dependent_tasks.last.dependent_task
        flow :margin_left => margin do
          background palegreen, :width => (final_one.time_estimate * 81)
          para "#{final_one.title}"
        end
      end
      end

    end
  end

end