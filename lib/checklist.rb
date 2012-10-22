require_relative 'colleague'

class Checklist < Colleague

  @@total_num_tasks = 0

  def add_task(task)
    @@total_num_tasks += 1
    @num_projects += 1
    task.id = @@total_num_tasks
    @projects << task
    CSV.open('lib/tasks.csv', 'ab') do |csv|
      csv << [task.id, task.title, task.deadline.to_i, task.type, task.start_time.to_i, task.notes, task.status, task.project ? task.project.id : nil, task.time_estimate.to_i, task.dependent_task ? task.dependent_task.id : nil ]
    end
  end

  def add_past_task(task)
    @num_projects += 1
    @@total_num_tasks += 1
    task.id = @@total_num_tasks
    @projects << task
  end
  def remove_task(task)
    @active_projects -= 1
    @projects.delete(task)
    delete(task.id)
    CSV.open('lib/tasks_archive.csv', 'ab') do |csv|
      csv << [task.id, task.title, task.deadline.to_i, task.type, task.start_time.to_i, task.notes, task.status, task.project ? task.project.id : nil, task.time_estimate.to_i, task.dependent_task ? task.dependent_task.id : nil ]
    end
  end

  def num_complete
    complete_tasks = projects.select{ |task| task.status == :complete }
    complete_tasks ? complete_tasks.size : 0
  end

  def percent_complete
    ((num_complete * 100.0) / num_projects) / 100
  end

  def dependent_time_span
    dependent_tasks = projects.select{ |task| task.dependent_task }
    dependent_tasks.sort_by!{ |task| task.start_time }
    last = dependent_tasks.last.dependent_task
    days = (last.deadline - dependent_tasks[0].start_time) / DAY 
  end

  def have_time_estimate?(array) 
    temp = array.select{ |task| task.time_estimate }
    temp.size == array.size && array.last.dependent_task.time_estimate ? true : false
  end

end