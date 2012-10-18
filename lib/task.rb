require_relative 'project'
require_relative 'constants'
require_relative 'project_file'

class Task < Project
  attr_reader :project, :time_estimate, :dependent_task

  def project= project
    @project = project
  end

  def time_estimate= num_days
    return if num_days.nil?
    !id ? @time_estimate = num_days : @time_estimate = update(@id, :time_estimate, num_days)
    @deadline = @start_time + (num_days * DAY)
  end

  def start_time= time
    !id ? @start_time = time : @start_time = update(@id, :start, time)
    @deadline = @start_time + (@time_estimate * DAY) if @time_estimate
  end

  def dependent_task= task
    return @dependent_task = task if task.is_a? Fixnum
    !id ? @dependent_task = task : @dependent_task = update(@id, :dependent_task, task)
    task.start_time = @deadline unless task.nil?
  end

end