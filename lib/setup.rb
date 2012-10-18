require_relative 'project_file'
require_relative 'project'
require_relative 'colleague'
require_relative 'client_manager'
require_relative 'client'
require_relative 'client_file'
require_relative 'task'
require_relative 'checklist'

class Setup

  include Client_file
  include Project_file

  attr_reader :colleague, :client_manager, :tasks

  def initialize colleague, client_manager
    @colleague = colleague
    @client_manager = client_manager
    @tasks = []
  end

  def client_history
    client_array = []
    clients = read_clients
    clients.each do |hash|
      client = Client.new
      client.id = hash[:id].to_i
      client.first_name = hash[:first_name]
      client.last_name = hash[:last_name]
      client.email = hash[:email]
      client.phone = hash[:phone]
      @client_manager.add_past_client(client)
      client_array << client
    end
    client_array
  end

  def project_history
    project_array = []
    string = ""
    projects = read 
    projects.each do |hash|
      project = Project.new
      project.id = hash[:id].to_i
      project.title = hash[:title]
      project.type = hash[:type]
      project.notes = hash[:notes]
      project.status = hash[:status].to_sym
      project.deadline = hash[:deadline].to_i == 0 ? nil : Time.at(hash[:deadline].to_i)
      project.start_time = Time.at(hash[:start].to_i)
      project.client = @client_manager.client(hash[:client].to_i)
      @colleague.add_past_project(project)
      project_array << project
    end
    project_array
  end

  def task_history
    tasks = read_tasks
    tasks.each do |hash|
      @colleague.projects.each do |project|
        if hash[:project].to_i == project.id
          task = Task.new
          if !project.checklist
            checklist = Checklist.new
            project.checklist = checklist
          end
          task.project = project
          project.checklist.add_past_task(task)
          task.id = hash[:id].to_i
          task.title = hash[:title]
          task.status = hash[:status].to_sym
          task.deadline = hash[:deadline].to_i == 0 ? nil : Time.at(hash[:deadline].to_i)
          task.start_time = Time.at(hash[:start].to_i)
          task.time_estimate = hash[:time_estimate].to_i == 0 ? nil : hash[:time_estimate].to_i
          # task temporarily saves the id of it's dependent task this will be reset to hold the actual object 
          # in dependent_task_history
          task.dependent_task = hash[:dependent_task].to_i == 0 ? nil : hash[:dependent_task].to_i
          @tasks << task
        end
      end
    end
  end

  def dependent_task_history
    # task_hash = read_tasks
    # @tasks.each do |task|
    #   if task.dependent_task
    #     task_hash.each do |hash|
    #       if task.dependent_task == hash[:id].to_i
            
    #       end
    #     end
    #   end
    # end
    projects_with_checklists = @colleague.projects.select{ |project| project.checklist }
    projects_with_checklists.each do |project|
      checklist = project.checklist
      dependent_tasks = project.checklist.projects.select{ |task| task.dependent_task }
      dependent_tasks.each do |task|
        task.dependent_task = checklist.project(task.dependent_task)
      end
    end
  end


end