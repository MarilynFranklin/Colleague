require 'lib/client'
require 'lib/client_manager'
require 'lib/project'
require 'lib/colleague'
require 'lib/project_file'
require 'lib/setup'


Shoes.app :title => 'Colleague', :width => 1000 do
  colleague = Colleague.new
  client_manager = Client_manager.new
  setup = Setup.new(colleague, client_manager)
  clients = setup.client_history
  projects = setup.project_history

  @main_frame = flow {

    @title = edit_line
    button "Add project" do
      project = Project.new
      project.title = @title.text
      colleague.add_project(project)

      @titles.append do
        flow do
          para @title.text + "#{colleague}"
          button "view" do
            @view_details_frame
          end
        end
      end
      @history = stack
      @history.append do
        stack do
          projects.each do |past_project|
            para "#{past_project[:title]}"
          end
        end
      end
      @titles = stack
    end
  }

  @view_details_frame = flow {
    stack do
      flow do
        @title_slot = stack(:width => 100) { para "title: #{project.title}" }
        @button_slot = stack(:width => 25){button "edit" do
         @title_edit.show() 
         @button_slot.hide()
        end }
        @title_edit = flow(:width => 500) {
            @new_title = edit_line
            button 'Add' do
              project.title = @new_title.text
              @title_slot.clear{ para "title: #{project.title}" }
              @title_edit.hide()
              @button_slot.show()
              refresh_list
            end
        }
        @title_edit.hide()
      end
      flow do
        para "start:"
        para "#{Time.at(project.start_time).to_date}"
      end
      flow do  
        para 'notes:'
        para "#{project.notes}"
      end
    end
  }

  @view_details_frame.hide()


end