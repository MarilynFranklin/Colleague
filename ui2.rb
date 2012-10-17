require 'lib/client'
require 'lib/client_manager'
require 'lib/project'
require 'lib/colleague'
require 'lib/project_file'
require 'lib/setup'

Shoes.app :title => 'Colleague', :width => 1000 do
  @colleague = Colleague.new
  @client_manager = Client_manager.new
  setup = Setup.new(@colleague, @client_manager)
  setup.client_history
  setup.project_history

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
          open_edit_window(project, self, :refresh, @client_manager)
        end
        button "remove" do
          @colleague.remove_project(project)
          refresh
        end
        c = check; title = para "#{project.title}", :stroke => color(project)
        c.click(){ update_status(project, self) }
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
          open_client_edit_window(client, self, :refresh_clients)
        end
        para "#{client.first_name} #{client.last_name}"
      end
    end
  end

#==================Main Window View====================#

  client_add = flow
  project_add = flow do
    @title = edit_line
    button "Add project" do
      project = Project.new
      project.title = @title.text
      @colleague.add_project(project)
      refresh
    end
    view = stack(:width => 1) do
      button "View Clients" do
        refresh_clients
        project_add.hide()
        client_add.show()
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
  sort_box = stack
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
      view(:is_urgent?)
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

#================== Client Edit Window ====================#

  def open_client_edit_window(client, shoes_object, method)
    window :title => "#{client.first_name} #{client.last_name}" do
      @main_app = shoes_object
      @refresh_history = method
      stack do
        def edit_client_flow(client_object, caption, getter, setter)
          edit = flow
          slot = stack(:width => 200){ para "#{caption}: #{client_object.send getter}" }
          button = stack(:width => 1) do
            button 'edit' do
              edit.show()
              button.hide()
            end
          end
          edit = flow(:width => 500) do
            update = edit_line
            button 'Add' do
              client_object.send setter, update.text
              slot.clear{ para "#{caption}: #{client_object.send getter}" }
              edit.hide()
              button.show()
              @main_app.send(@refresh_history)
            end
          end
          edit.hide()
        end

        flow do
          edit_client_flow(client, "First Name", :first_name, :first_name=)
        end

        flow do
          edit_client_flow(client, "Last Name", :last_name, :last_name=)
        end

        flow do
          edit_client_flow(client, "Email", :email, :email=)
        end

        flow do
          edit_client_flow(client, "Phone", :phone, :phone=)
        end
      end
    end
  end

#================== Project Edit Window ====================#

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
#================== End Project Edit Window ====================#
end