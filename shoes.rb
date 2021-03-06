require 'lib/client'
require 'lib/client_manager'
require 'lib/project'
require 'lib/colleague'
require 'lib/project_file'
require 'lib/setup'
require 'lib/task'
require 'lib/checklist'
require 'lib/constants'
require 'shoes/client_edit_window'
require 'shoes/project_edit_window'
require 'shoes/task_edit_window'
require 'shoes/task_window'

Shoes.app :title => 'Colleague', :width => 1000 do
  @colleague = Colleague.new
  @client_manager = Client_manager.new
  setup = Setup.new(@colleague, @client_manager)
  setup.client_history
  setup.project_history
  setup.task_history
  setup.dependent_task_history

  @history = stack
#==================Project Methods====================#
  def color(project)
    return green if project.status == :complete
    return if !project.deadline
    if project.is_due_soon?
      orange
    elsif project.is_urgent?
      red
    else
      black
    end
  end

  def refresh 
    @history.clear do 
      @colleague.projects.each do |project|
        history_stack(project)
      end
    end
  end

  def view(method)
    @history.clear do
      @colleague.projects.each do |project|
        history_stack(project) if project.deadline && project.send(method) 
      end
    end
  end

  def sort_by(method, match)
    @history.clear do
      @colleague.projects.each do |project|
        history_stack(project) if project.send(method) == match
      end
    end
  end

  def status_bar(project)
     status_bar = progress :width => 0.25
     animate do |i|
      if project.status == :complete 
        status_bar.fraction = 100
      elsif !project.checklist
        status_bar.fraction = 0
      else
        status_bar.fraction = project.checklist.percent_complete
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
          title_slot.open_edit_window(project, self, :refresh, @client_manager)
        end
        button "tasks" do 
          title_slot.open_task_window(project)
        end
        button "remove" do
          @colleague.remove_project(project)
          refresh
        end
        c = check; title = para "#{project.title}", :stroke => color(project)
        c.click(){ update_status(project, self) }
        status_bar(project)
      end
    end
  end
  
#==================client Methods====================#

  def refresh_clients 
    @history.clear do
      @client_manager.clients.each do |client|
        client_history_stack(client)
      end
    end
  end

  def client_history_stack(client)
    stack do
      name_slot = flow do
        button "view" do
          name_slot.open_client_edit_window(client, self, :refresh_clients)
        end
        para "#{client.first_name} #{client.last_name}"
      end
    end
  end

#==================Main Window View====================#

  client_add = flow
  sort_box = stack
  project_add = flow do
    @title = edit_line
    button "Add project" do
      project = Project.new
      project.title = @title.text
      @colleague.add_project(project)
      @title.text = ""
      refresh
    end
    view = stack(:width => 1) do
      button "View Clients" do
        refresh_clients
        project_add.hide()
        client_add.show()
        sort_box.hide()
      end
    end
  end

  client_add = flow do
    add_field = flow do 
      @first_name = edit_line
      @last_name = edit_line
      add = button "Add client" do
        client = Client.new
        client.first_name = @first_name.text
        client.last_name = @last_name.text
        @client_manager.add_client(client)
        @first_name.text = ""
        @last_name.text = ""
        refresh_clients
      end
      view = stack(:width => 1) do
        button "View projects" do
          refresh
          project_add.show()
          client_add.hide()
          sort_box.show()
        end
      end
    end
  end
  client_add.hide()

#================== Display / sort buttons ====================#

  view = flow do
    projects = stack(:width => 1) do
      button "View Projects" do
        refresh
        project_add.show()
        client_add.hide()
        view.hide()
      end
    end
  end
  client_picker = flow do
    list = ["Client:"]
    @client_manager.clients.each{ |client| list << "#{client.id} #{client.first_name} #{client.last_name}"}
    clients = list_box :items => list
    clients.change() do
      client = @client_manager.client(clients.text[/^\d+/].to_i)
      sort_by(:client, client)
      client_picker.hide()
      sort_box.show()
    end
  end
  client_picker.hide()

  sort = ["Sort By:", "Due Today", "Due This Week", "Clients"]

  sort_box = list_box :items =>sort
  sort_box.choose(item:'Sort By:')
  sort_box.change() do
    if "Due Today" == sort_box.text
      view(:due_today?)
      view.show()
    elsif "Due This Week" == sort_box.text
      view(:is_due_this_week?)
      view.show()
    elsif "Clients" == sort_box.text
      client_add.hide()
      project_add.hide()
      sort_box.hide()
      view.show()
      @history.clear{  }
      client_picker.show()
    end      
  end

  @history = stack
  @history.append do
    refresh
  end
  view.hide()
  project_add.show()
end
