module Client_file

  def read
    file = File.open('lib/clients.csv', 'r')
    clients = []
    while (line = file.gets)
      columns = line.split(",")
      clients.push({id: columns[0], first_name: columns[1], last_name: columns[2], email: columns[3], phone: columns[4]})      
    end
    file.close
    clients
  end

  def update(id, key, value)
    projects = read
    project_index = id - 1
    projects[project_index][key] = value
    lines = File.readlines('lib/clients.csv')
    lines[project_index] = projects[project_index].values.join(",")
    File.open('lib/clients.csv', 'w') do |csv|
      lines.each{ |line| csv.puts(line) }
    end
    value
  end 

end