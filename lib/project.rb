require_relative 'client'
require_relative 'constants'
require_relative 'project_file'

class Project
  include Project_file
  attr_reader :title, :status, :type, :notes, :start_time, :deadline, :client, :id

  def initialize *title
    if title.size == 1 
      @title = title
    end
    @status = :incomplete
    @start_time = Time.now
  end

  def type= type
    !id ? @type = type : @type = update(@id, :type, type)
  end

  def notes= notes
    !id ? @notes = notes : @notes = update(@id, :notes, notes)
  end

  def start_time= time
    !id ? @start_time = time : @start_time = update(@id, :start, time)
  end

  def deadline= time
    !id ? @deadline = time : @deadline = update(@id, :deadline, time)
  end

  def client= client
    !id ? @client = client : @client = update(@id, :client, client )
  end

  def status= status
    !id ? @status = status : @status = update(@id, :status, status)
  end

  def time_till_due
    time_till_due = @deadline - Time.now
  end

  def is_urgent?
    time_till_due <= DAY ? true : false
  end

  def is_due_soon?
    time_till_due > DAY && time_till_due <= (3 * DAY) ? true : false
  end

  def is_due_later?
    time_till_due > (3 * DAY) ? true : false
  end

  def id= project_number
    @id = project_number
  end

  def title= new_title
    !id ? @title = new_title : @title = update(@id, :title, new_title)
  end

end