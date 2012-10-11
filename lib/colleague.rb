require_relative 'project'
require 'csv'

class Colleague

  attr_reader :num_projects

  def initialize
    @num_projects = 0
  end

  def add_project(project)
    @num_projects += 1
    project.id = @num_projects
    CSV.open('lib/projects.csv', 'ab') do |csv|
      csv << [@num_projects, project.title, project.deadline.to_i, project.type, project.start_time.to_i, project.notes, project.status, project.client ? project.client.id : nil]
    end
  end

  def add_past_project project
    @num_projects += 1
  end

end