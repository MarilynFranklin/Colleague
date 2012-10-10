require 'client'

class Client_manager
  attr_reader :num_clients

  def initialize
    @num_clients = 0
  end

  def add_client client
    @num_clients += 1
    client.id = @num_clients
    CSV.open('lib/clients.csv', 'ab') do |csv|
      csv << [@num_clients, client.first_name, client.last_name, client.email, client.phone]
    end
  end

end