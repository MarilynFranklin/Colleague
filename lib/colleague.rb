require 'project'

class Colleague
  attr_reader :num_projects

  def initialize
    @num_projects = 0
  end

  def add_project(project)
    @num_projects += 1
  end

end