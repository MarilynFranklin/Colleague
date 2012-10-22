module Shoes::Types

  def open_edit_window(project, shoes_object, method, client_manager)
      @window = window :title => project.title, :width => 1000 do
        @main_app = shoes_object
        @refresh_history = method
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

        flow do
          edit_time_flow(project, 'Start', :start_time, :start_time=)
        end

        flow do
          edit_time_flow(project, 'Deadline', :deadline, :deadline=)
        end

        flow do  
          edit_project_flow(project, 'Notes', :notes, :notes=)
        end

        flow do  
          edit_project_flow(project, 'Project Type', :type, :type=)
        end

        
        flow do  
          edit = flow 
          slot = stack(:width => 200) do
            if project.client
              para "Client: #{project.client.first_name} #{project.client.last_name}" 
            else
              para "Client: "
            end
          end
          button = stack(:width => 1) do
            button 'edit' do
              edit.show()
              button.hide()
            end
          end
          edit = flow(:width => 500) do
            list = []
            client_manager.clients.each do |client|
              list << "#{client.id} #{client.first_name} #{client.last_name}"
            end
            client_edit = list_box :items => list
            client_edit.change() do
              client = client_manager.client(client_edit.text[/^\d+/].to_i)
              project.client = client
              slot.clear do
                if project.client
                  para "Client: #{project.client.first_name} #{project.client.last_name}"  
                else 
                  para "Client: "
                end
              end
              button.show()
              edit.hide()
            end
          end
          edit.hide()

        end


      end
    end
  end

end