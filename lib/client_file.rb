module Client_file

  def read_clients
    file = File.open('files/clients.csv', 'r')
    clients = []
    while (line = file.gets)
      columns = line.split(",")
      clients.push({id: columns[0], first_name: columns[1], last_name: columns[2], email: columns[3], phone: columns[4]})      
    end
    file.close
    clients
  end

  def update_clients(id, key, value)
    clients = read_clients
    client_index = id - 1
    clients[client_index][key] = value
    lines = File.readlines('files/clients.csv')
    lines[project_index] = clients[client_index].values.join(",")
    File.open('files/clients.csv', 'w') do |csv|
      lines.each{ |line| csv.puts(line) }
    end
    value
  end 

end