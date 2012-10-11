require 'client'
require 'client_manager'
require 'project'
require 'colleague'

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

Shoes.app do
  @title = edit_line
  button "Add project" do
    project = Project.new(@title.text)
    colleague = Colleague.new
    colleague.add_project(project)
    @titles.append do
      para @title.text + "#{colleague}"
    end 
    @title.text = ''
  end
  @titles = stack
end