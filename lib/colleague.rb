require_relative 'project'
require 'csv'

class Colleague

  attr_reader :num_projects, :projects

  def initialize
    @num_projects = 0
    @projects = []
  end

  def add_project(project)
    @num_projects += 1
    project.id = @num_projects
    @projects << project
    CSV.open('lib/projects.csv', 'ab') do |csv|
      csv << [@num_projects, project.title, project.deadline.to_i, project.type, project.start_time.to_i, project.notes, project.status, project.client ? project.client.id : nil]
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