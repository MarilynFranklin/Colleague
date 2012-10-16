require 'lib/client'
require 'lib/client_manager'
require 'lib/project'
require 'lib/colleague'
require 'lib/project_file'
require 'lib/setup'

Shoes.app :title => 'Colleague', :width => 1000 do
  @colleague = Colleague.new
  client_manager = Client_manager.new
  setup = Setup.new(@colleague, client_manager)
  clients = setup.client_history
  projects = setup.project_history

  def refresh 
    @history.clear do 
      @colleague.projects.each do |project|
        history_stack(project)
      end
    end
  end

  def history_stack(project)
    stack do
      def update_status(project, c)
        if project.status == :incomplete
          project.status = :complete
        else
          project.status = :incomplete
        end
        refresh
      end
      title_slot = flow do
        button "view" do
          open_edit_window(project, self, :refresh)
        end
        c = check; title = para "#{project.title}", :stroke => project.status == :complete ? green : black
        c.click(){ update_status(project, self) }
      end
    end
  end



  @title = edit_line
  button "Add project" do
    project = Project.new
    project.title = @title.text
    @colleague.add_project(project)
    refresh
  end

  @history = stack
  @history.append do
    refresh
  end

        def open_edit_window(project, shoes_object, method)
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


            flow do
              edit_project_flow(project, 'Title', :title, :title=)
            end

            flow do
              @start_slot = stack(:width => 200){ para "start: #{Time.at(project.start_time).to_date}" }
              @button_start = stack(:width => 25){button "edit" do
              @start_edit.show() 
              @button_start.hide()
              end }
              @start_edit = flow(:width => 500) {
                  month_edit = edit_line(:width => 25)
                  para "/ " 
                  day_edit = edit_line(:width => 25)
                  para "/ " 
                  year_edit = edit_line(:width => 50)
                  para "( MM/DD/YYYY )" 
                  button 'Add' do
                    @start_slot.clear{ para "start: #{Time.at(project.start_time).to_date}" }
                    @start_edit.hide()
                    @button_start.show()
                  end
              }
              @start_edit.hide()
            end

            flow do  
              edit_project_flow(project, 'Notes', :notes, :notes=)
            end
          end
        end
  end

end