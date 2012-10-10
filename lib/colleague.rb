require 'project'
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
      csv << [@num_projects, project.title, project.deadline, project.type, project.start_time, project.notes, project.status, project.client]
    end
  end

end