require 'lib/client'
require 'lib/client_manager'
require 'lib/project'
require 'lib/colleague'
require 'lib/project_file'
require 'lib/setup'

# Shoes.app :title => 'Colleague' do
#   para "Enter your project title"
#   @title = edit_line 
#   # button 'Go' do
#   #   title = @title.text
#   #   alert "the title is #{title}"
#   # end 

#   # para "projects"
#   # @projects = list_box :items => [projects_array]

# end

Shoes.app :title => 'Colleague', :width => 1000 do
  colleague = Colleague.new
  client_manager = Client_manager.new
  setup = Setup.new(colleague, client_manager)
  clients = setup.client_history
  projects = setup.project_history


  @title = edit_line
  button "Add project" do
    project = Project.new
    project.title = @title.text
    colleague.add_project(project)
    @history.append do
      flow do
        flow {
        button "view" do
          window :title => project.title, :width => 1000 do
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
          end
        end 
        check; para @title.text}
      end
    end 
    @title.text = ""
  end
  @history = stack
  @history.append do
    stack do
      projects.each do |past_project|
        flow {
        button "view" do
          window :title => past_project.title, :width => 1000 do

              def test_test(project)

                para "#{project}"
              end
            stack do
              flow do
                @title_slot = stack(:width => 200) { para "title: #{past_project.title}" }
                @test = stack{ test_test(past_project)

                }



                @button_title = stack(:width => 25){button "edit" do
                @title_edit.show() 
                @button_title.hide()
                end }
                @title_edit = flow(:width => 500) {
                    @new_title = edit_line
                    button 'Add' do
                      past_project.title = @new_title.text
                      @title_slot.clear{ para "title: #{past_project.title}" }
                      @title_edit.hide()
                      @button_title.show()
                    end
                }
                @title_edit.hide()
              end
              flow do
                @start_slot = stack(:width => 200){ para "start: #{Time.at(past_project.start_time).to_date}" }
                @button_start = stack(:width => 25){button "edit" do
                @start_edit.show() 
                @button_start.hide()
                end }
                @start_edit = flow(:width => 500) {
                    @new_start = edit_line
                    button 'Add' do
                      past_project.title = @new_start.text
                      @start_slot.clear{ para "title: #{past_project.title}" }
                      @start_edit.hide()
                      @button_start.show()
                    end
                }
                @start_edit.hide()
              end
              flow do  
                @update_notes = stack(:width => 200) { para "notes: #{past_project.notes}" }
                @button_slot = stack(:width => 25){button "edit" do
                @notes_edit.show() 
                @button_slot.hide()
                end }
                @notes_edit = flow(:width => 500) do
                    @new_notes = edit_line
                    button 'Add' do
                      past_project.title = @new_notes.text
                      @update_notes.clear{ para "title: #{past_project.title}" }
                      @notes_edit.hide()
                      @button_slot.show()
                    end
                end
                @notes_edit.hide()
              end
            end
          end
        end 
        check; para "#{past_project.title}" }
      end
    end
  end

  @titles = stack



  






  def refresh_list
    @history.clear {
      stack do
        projects.each do |past_project|
          para "#{past_project.title}"
        end
        # para "#{colleague.projects}"
      end
    }
  end
end