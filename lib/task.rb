require_relative 'project'

class Task < Project
  attr_reader :project

  def project= project
    @project = project
  end

end