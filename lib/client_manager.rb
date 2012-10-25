require_relative 'client'

class Client_manager
  attr_reader :num_clients, :clients

  def initialize
    @num_clients = 0
    @clients = []
  end

  def add_client client
    @num_clients += 1
    client.id = @num_clients
    @clients << client
    CSV.open('files/clients.csv', 'ab') do |csv|
      csv << [@num_clients, client.first_name, client.last_name, client.email, client.phone]
    end
  end

  def add_past_client client
    @num_clients += 1
    @clients << client
  end

  def client(id)
    match = nil
    @clients.each do |client|
      client.id == id ? match = client : nil
    end
    match
  end

end