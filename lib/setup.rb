require_relative 'project_file'
require_relative 'project'
require_relative 'colleague'
require_relative 'client_manager'
require_relative 'client'
require_relative 'client_file'

class Setup

  include Client_file
  include Project_file

  attr_reader :colleague, :client_manager

  def initialize colleague, client_manager
    @colleague = colleague
    @client_manager = client_manager
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

end