module Project_file

  def read
    file = File.open('lib/projects.csv', 'r')
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
    projects.each do |hash|
      match = projects.index(hash) if hash[:id].to_i == id 
    end
    match
  end

  def update(id, key, value)
    if self.class == Project
      projects = read
      file = "lib/projects.csv"
    else
      projects = read_tasks
      file = "lib/tasks.csv"
    end
    project_index = line_index(id, projects)
    if key == :client
      value ? projects[project_index][key] = value.id : value
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

  def delete(id)
    projects = read
    project_index = line_index(id, projects)
    lines = File.readlines('lib/projects.csv')
    lines.delete_at(project_index)
    File.open('lib/projects.csv', 'w') do |csv|
      lines.each{ |line| csv.puts(line) }
    end
  end

  def read_archive
    file = File.open('lib/projects_archive.csv', 'r')
    projects = []
    while (line = file.gets)
      columns = line.split(",")
      projects.push({id: columns[0], title: columns[1], deadline: columns[2], type: columns[3], start: columns[4], notes: columns[5], status: columns[6], client: columns[7] })      
    end
    file.close
    projects
  end

  def read_tasks
    file = File.open('lib/tasks.csv', 'r')
    projects = []
    while (line = file.gets)
      columns = line.split(",")
      projects.push({id: columns[0], title: columns[1], deadline: columns[2], type: columns[3], start: columns[4], notes: columns[5], status: columns[6], project: columns[7] })      
    end
    file.close
    projects
  end

end