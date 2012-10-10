require 'client'
require 'constants'

class Project

  attr_reader :title, :status, :type, :notes, :start_time, :deadline, :client

  def initialize title
    @title = title
    @status = :incomplete
    @start_time = Time.now
  end

  def type= type
    @type = type
  end

  def notes= notes
    @notes = notes
  end

  def start_time= time
    @start_time = time
  end

  def deadline= time
    @deadline = time
  end

  def client= client
    @client = "#{client.first_name} #{client.last_name}"
  end

  def status= status
    @status = status
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

end