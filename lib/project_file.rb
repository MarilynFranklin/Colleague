module Project_file

  def read
    file = File.open('files/projects.csv', 'r')
    projects = []
    while (line = file.gets)
      columns = line.split(",")
      projects.push({id: columns[0], title: columns[1], deadline: columns[2], type: columns[3], start: columns[4], notes: columns[5], status: columns[6], client: columns[7]})      
    end
    file.close
    projects
  end

  def line_index(id, projects)
    match = nil
    projects.each { |hash| match = projects.index(hash) if hash[:id].to_i == id }
    match
  end

  def update(id, key, value)
    projects = file_contents
    file = file_name
    project_index = line_index(id, projects)
    if key == :client || key == :dependent_task
      value.nil? ? projects[project_index][key] = nil : projects[project_index][key] = value.id
    elsif key == :deadline || key == :start
      projects[project_index][key] = value.to_i
    else
      projects[project_index][key] = value
    end
    lines = File.readlines(file)
    lines[project_index] = projects[project_index].values.join(",")
    File.open(file, 'w') do |csv|
      lines.each{ |line| csv.puts(line) }
    end
    value
  end 

  def file_name 
    self.class == Colleague || self.class == Project ? file = "files/projects.csv" : file = "files/tasks.csv"
  end

  def file_contents
    self.class == Colleague || self.class == Project ? read : read_tasks
  end

  def delete(id)
    file = file_name
    projects = file_contents
    project_index = line_index(id, projects)
    lines = File.readlines(file)
    lines.delete_at(project_index)
    File.open(file, 'w') do |csv|
      lines.each{ |line| csv.puts(line) }
    end
  end

  def read_archive
    file = File.open('files/projects_archive.csv', 'r')
    projects = []
    while (line = file.gets)
      columns = line.split(",")
      projects.push({id: columns[0], title: columns[1], deadline: columns[2], type: columns[3], start: columns[4], notes: columns[5], status: columns[6], client: columns[7], time_estimate: columns[8], dependent_task: columns[9]  })      
    end
    file.close
    projects
  end

  def read_tasks
    file = File.open('files/tasks.csv', 'r')
    projects = []
    while (line = file.gets)
      columns = line.split(",")
      projects.push({id: columns[0], title: columns[1], deadline: columns[2], type: columns[3], start: columns[4], notes: columns[5], status: columns[6], project: columns[7], time_estimate: columns[8], dependent_task: columns[9] })      
    end
    file.close
    projects
  end

end