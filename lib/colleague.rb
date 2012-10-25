require_relative 'project'
require_relative 'project_file'
require 'csv'

class Colleague

  include Project_file

  attr_reader :num_projects, :projects, :active_projects

  def initialize
    @num_projects = 0
    @active_projects = 0
    @projects = []
  end

  def add_project(project)
    @num_projects += 1
    @active_projects += 1
    project.id = @num_projects
    @projects << project
    CSV.open('files/projects.csv', 'ab') do |csv|
      csv << [project.id, project.title, project.deadline.to_i, project.type, project.start_time.to_i, project.notes, project.status, project.client ? project.client.id : nil]
    end
  end

  def remove_project(project)
    @active_projects -= 1
    @projects.delete(project)
    delete(project.id)
    CSV.open('files/projects_archive.csv', 'ab') do |csv|
      csv << [project.id, project.title, project.deadline.to_i, project.type, project.start_time.to_i, project.notes, project.status, project.client ? project.client.id : nil]
    end
  end

  def add_past_project project
    @num_projects += 1
    @projects << project
  end

  def project(id)
    match = nil
    @projects.each do |project|
      project.id == id ? match = project : nil
    end
    match
  end

end