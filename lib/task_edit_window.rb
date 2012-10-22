module Shoes::Types

  def open_task_edit_window(project, shoes_object, method, parent_project_object)
        @window = window :title => project.title, :width => 1000 do
          @main_app = shoes_object
          @refresh_history = method
          @parent_project = parent_project_object
        stack do
          def edit_project_flow(project_object, caption, getter, setter)
            edit = flow
            slot = stack(:width => 200){ para "#{caption}: #{project_object.send getter}" }
            button = stack(:width => 1) do
              button 'edit' do
                edit.show()
                button.hide()
              end
            end
            edit = flow(:width => 500) do
              update = edit_line
              button 'Add' do
                project_object.send setter, update.text
                slot.clear{ para "#{caption}: #{project_object.send getter}" }
                edit.hide()
                button.show()
                @main_app.send(@refresh_history)
              end
            end
            edit.hide()
          end

          def edit_time_flow(project_object, caption, getter, setter)
            edit = flow 
            slot = stack(:width => 200)do
              if project_object.send( getter ).to_i == 0
                para "#{caption}:"
              else                  
                para "#{caption}: #{project_object.send(getter).to_date}" 
              end
            end
            button = stack(:width => 1) do
              button 'edit' do
                edit.show()
                button.hide()
              end
            end
            edit = flow(:width => 500) do
                month_edit = edit_line(:width => 30)
                para "/ " 
                day_edit = edit_line(:width => 30)
                para "/ " 
                year_edit = edit_line(:width => 50)
                para "( MM/DD/YYYY )" 
              button 'Add' do
                project_object.send setter, Time.local(year_edit.text.to_i, month_edit.text.to_i, day_edit.text.to_i)
                slot.clear{ para "#{caption}: #{project_object.send(getter).to_date}" }
                edit.hide()
                button.show()
                @main_app.send(@refresh_history)
              end
            end
            edit.hide()

          end 

          flow do
            edit_project_flow(project, 'Title', :title, :title=)
          end

          @start = flow do
            edit_time_flow(project, 'Start', :start_time, :start_time=)
          end

          @deadline = flow do
            edit_time_flow(project, 'Deadline', :deadline, :deadline=)
          end

          flow do
            edit = flow 
            slot = stack(:width => 200)do
              if project.time_estimate.to_i == 0
                para "Time Estimate:"
              else                  
                para "Time Estimate: #{project.time_estimate.to_i} days" 
              end
            end
            button = stack(:width => 1) do
              button 'edit' do
                edit.show()
                button.hide()
              end
            end
            edit = flow(:width => 500) do
                time_edit = edit_line(:width => 60)
                para "(days)" 
              button 'Add' do
                project.time_estimate = time_edit.text.to_i
                slot.clear{ para "Time Estimate: #{project.time_estimate.to_i} days" }
                @deadline.clear{ edit_time_flow(project, 'Deadline', :deadline, :deadline=) }
                edit.hide()
                button.show()
              end
            end
            edit.hide()
            @main_app.send(@refresh_history)

          end

          flow do  
            edit_project_flow(project, 'Notes', :notes, :notes=)
          end

          flow do    
            edit = flow 
            slot = stack(:width => 200) do
              if project.dependent_task
                para "Dependent task: #{project.dependent_task.title}" 
              else
                para "Dependent task: "
              end
            end
            button = stack(:width => 1) do
              button 'edit' do
                edit.show()
                button.hide()
              end
            end
            edit = flow(:width => 500) do
              list = [" "]
              @parent_project.checklist.projects.each do |task|
                list << "#{task.id} #{task.title}" if project != task && task.dependent_task != project
              end
              task_edit = list_box :items => list
              task_edit.change() do
                id = task_edit.text[/^\d+/].to_i
                task_edit.text == "" ?  task = nil : task = @parent_project.checklist.project(task_edit.text[/^\d+/].to_i)
                project.dependent_task = task
                slot.clear do
                  if project.dependent_task
                    para "Dependent task: #{project.dependent_task.title}"   
                  else 
                    para "Dependent task: "
                  end
                end
                @start.clear{ edit_time_flow(project, 'Start', :start_time, :start_time=) }
                button.show()
                edit.hide()
              end
            end
            edit.hide()
            @main_app.send(@refresh_history)

          end
        end
    end
  end
end