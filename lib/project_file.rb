module Project_file

  def read
    file = File.open('lib/projects.csv', 'r')
    projects = []
    while (line = file.gets)
      columns = line.split(",")
      projects.push({id: columns[0], title: columns[1], deadline: columns[2], type: columns[3], start: columns[4], notes: columns[5], status: columns[6], client: columns[7] })      
    end
    file.close
    projects
  end

  def update(id, key, value)
    projects = read
    project_index = id - 1
    if key == :client
      value ? projects[project_index][key] = value.id : value
    elsif key == :deadline || key == :start
      projects[project_index][key] = value.to_i
    else
      projects[project_index][key] = value
    end
    lines = File.readlines('lib/projects.csv')
    lines[project_index] = projects[project_index].values.join(",")
    File.open('lib/projects.csv', 'w') do |csv|
      lines.each{ |line| csv.puts(line) }
    end
    value
  end 

end