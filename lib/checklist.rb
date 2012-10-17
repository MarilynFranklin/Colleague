require_relative 'colleague'

class Checklist < Colleague

  def add_project(project)
    @num_projects += 1
    @active_projects += 1
    project.id = @num_projects
    @projects << project
    CSV.open('lib/tasks.csv', 'ab') do |csv|
      csv << [@num_projects, project.title, project.deadline.to_i, project.type, project.start_time.to_i, project.notes, project.status, project.client ? project.client.id : nil]
    end
  end

end