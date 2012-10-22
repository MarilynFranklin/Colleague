require 'test/unit'
require 'colleague'
require 'project'
require 'client'
require 'constants'
require 'project_file'
require 'client_manager'
require 'setup'
require 'checklist'
require 'task'

class ColleagueTest < Test::Unit::TestCase
#==============project object attributes================#

  def test_01_project_exists
    project = Project.new
    assert_equal Project, project.class
  end
  def test_02_project_default_status_is_incomplete
    project = Project.new
    assert_equal :incomplete, project.status
  end
  def test_03_can_set_project_type
    project = Project.new
    project.type = "web design"
    assert_equal "web design", project.type
  end
  def test_04_can_set_project_type
    project = Project.new
    project.type = "logo"
    assert_equal "logo", project.type
  end
  def test_05_can_add_project_notes
    project = Project.new
    project.notes = "remember this!"
    assert_equal "remember this!", project.notes
  end
  def test_06_projects_should_set_start_time_automatically
    project = Project.new
    assert_equal Time.now.hour, project.start_time.hour
  end
  def test_06b_user_can_change_start_time
    project = Project.new
    time = Time.local(2012, 3, 2)
    project.start_time = time
    assert_equal time, project.start_time
  end
  def test_07_can_set_project_deadline
    project = Project.new
    time = Time.local(2012, 3, 2, 16, 45, 02)
    project.deadline = time
    assert_equal time, project.deadline
  end
#==============client object tests================#
  def test_08_can_set_client
    client = Client.new
    assert_equal Client, client.class
  end
  def test_09_can_set_client_first_name
    client = Client.new
    client.first_name = "Jane"
    assert_equal "Jane", client.first_name
  end
  def test_10_can_set_client_last_name
    client = Client.new
    client.last_name = "Smith"
    assert_equal "Smith", client.last_name
  end
  def test_11_can_set_client_email
    client = Client.new
    client.email = "smith@gmail.com"
    assert_equal "smith@gmail.com", client.email
  end
  def test_12_can_set_client_phone
    client = Client.new
    client.phone = "555-5555"
    assert_equal "555-5555", client.phone
  end
  def test_12b_client_manager_tallies_num_clients
    cm = Client_manager.new
    client1 = Client.new
    client2 = Client.new
    client3 = Client.new
    cm.add_client(client1)
    cm.add_client(client2)
    cm.add_client(client3)
    assert_equal 3, cm.num_clients
    File.open('lib/clients.csv', 'w') { |file| file.truncate(0) }
  end
  def test_12c_client_has_id
    cm = Client_manager.new
    client = Client.new
    cm.add_client(client)
    assert_equal 1, client.id
    File.open('lib/clients.csv', 'w') { |file| file.truncate(0) }
  end
  def test_12e_client_has_id
    cm = Client_manager.new
    client = Client.new
    client2 = Client.new
    cm.add_client(client)
    cm.add_client(client2)
    assert_equal 2, client2.id
    File.open('lib/clients.csv', 'w') { |file| file.truncate(0) }
  end
  def test_13_project_can_set_client
    client = Client.new
    client.first_name = "Jane"
    client.last_name = "Smith"
    cm = Client_manager.new
    cm.add_client(client)
    project = Project.new
    project.client= client
    assert_equal 1, project.client.id
    File.open('lib/clients.csv', 'w') { |file| file.truncate(0) }
  end
  def test_14_project_can_set_client
    client = Client.new
    client2 = Client.new
    cm = Client_manager.new
    cm.add_client(client)
    cm.add_client(client2)
    project = Project.new
    project.client= client2
    assert_equal 2, project.client.id
    File.open('lib/clients.csv', 'w') { |file| file.truncate(0) }
  end
  def test_14b_can_find_client_by_id
    client = Client.new
    client2 = Client.new
    cm = Client_manager.new
    cm.add_client(client)
    cm.add_client(client2)
    project = Project.new
    project.client= client2
    assert_equal client2, cm.client(2)
    File.open('lib/clients.csv', 'w') { |file| file.truncate(0) }
  end
#==============project object operations================#
  def test_15_can_set_project_as_complete
    project = Project.new
    project.status= :complete
    assert_equal :complete, project.status
  end
  def test_16_time_till_due_is_correct
    project = Project.new
    project.deadline= Time.now + (3 * DAY)
    assert_equal true, project.time_till_due <= (3 * DAY) && project.time_till_due > (2 * DAY)
  end
  def test_17_time_till_due_is_correct
    project = Project.new
    project.deadline= Time.now + (4 * DAY)
    assert_equal false, project.time_till_due == (3 * DAY)
  end
  def test_18_is_urgent_returns_true_if_one_day_from_now
    project = Project.new
    project.deadline= Time.now + DAY
    assert_equal true, project.is_urgent?
  end
  def test_19_is_due_soon_returns_true_if_due_between_3_and_1_day
    project = Project.new
    project.deadline= Time.now + (2 * DAY)
    assert_equal true, project.is_due_soon?
  end
  def test_20_due_this_week
    project = Project.new
    project.deadline= Time.now + (7 * DAY)
    assert_equal true, project.is_due_this_week?
  end
  def test_21_due_this_week
    project = Project.new
    project.deadline= Time.now + (9 * DAY)
    assert_equal false, project.is_due_this_week?
  end

  def test_22_deadline
    project = Project.new
    assert_equal nil, project.deadline
  end

#==============colleague object tests================#
  def test_23_colleague_is_object
    proj_manager = Colleague.new
    assert_equal Colleague, proj_manager.class
  end
  
  def test_24_colleague_keeps_track_of_num_projects_ever_created
    proj_manager = Colleague.new
    assert_equal 0, proj_manager.num_projects
  end

  def test_25_colleague_keeps_track_of_num_projects_ever_created
    proj_manager = Colleague.new
    project = Project.new
    project2 = Project.new
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    assert_equal 2, proj_manager.num_projects
    File.open('lib/projects.csv', 'w') {|file| file.truncate(0) }
  end
  
  def test_26_lines_index_is_correct
    proj_manager = Colleague.new
    project = Project.new
    project2 = Project.new
    project3 = Project.new
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    proj_manager.add_project(project3)
    projects = read
    assert_equal 1, line_index(project2.id, projects)
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end
  def test_27_colleague_sets_project_id_to_match_num_projects
    proj_manager = Colleague.new
    project = Project.new
    proj_manager.add_project(project)
    assert_equal 1, project.id
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end 
  def test_28_colleague_sets_project_id_to_match_num_projects
    proj_manager = Colleague.new
    project = Project.new
    project2 = Project.new
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    assert_equal 2, project2.id
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end 
  def test_29_colleague_keeps_track_of_active_projects
    proj_manager = Colleague.new
    project = Project.new
    project2 = Project.new
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    assert_equal 2, proj_manager.active_projects
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_30_Module_changes_start_time_after_project_added_to_file
    proj_manager = Colleague.new
    project = Project.new
    project2 = Project.new
    project.start_time = Time.local(2012, 10, 9, 22, 53,57)
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    project2.start_time = Time.local(2012, 10, 9, 22, 53,57)

    assert_equal project2.start_time.to_s, "2012-10-09 22:53:57 -0500"
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_31_can_change_project_title_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new
    proj_manager.add_project(project)
    project.title = "new title"
    assert_equal "new title", project.title
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_32_can_change_project_status_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new
    proj_manager.add_project(project)
    project.status = :complete
    assert_equal :complete, project.status
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_33_can_change_project_type_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new
    proj_manager.add_project(project)
    project.type = "web development"
    assert_equal "web development", project.type
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_34_can_change_project_notes_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new
    proj_manager.add_project(project)
    project.notes = "important"
    assert_equal "important", project.notes
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_35_can_change_project_client_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new
    proj_manager.add_project(project)
    client2 = Client.new
    client2.first_name = "Glen"
    project.client = client2
    assert_equal "Glen", project.client.first_name
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_36_can_change_project_client_name_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new
    proj_manager.add_project(project)
    client2 = Client.new
    client2.first_name = "Glen"
    project.client = client2
    client2.first_name = "Sam"
    assert_equal "Sam", project.client.first_name
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end  

  def test_37_projects_can_have_checklists
    project = Project.new
    checklist = Checklist.new
    project.checklist = checklist
    assert_equal checklist, project.checklist
  end
  def test_38_checklist_tasks_can_be_accessed_from_project
    project = Project.new
    checklist = Checklist.new
    task = Task.new
    task2 = Task.new
    checklist.add_task(task)
    checklist.add_task(task2)
    project.checklist = checklist
    assert_equal 2, project.checklist.num_projects
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_39_Colleague_stores_checklist_with_project
    c = Colleague.new
    project = Project.new
    checklist = Checklist.new
    task = Task.new
    task2 = Task.new
    checklist.add_task(task)
    checklist.add_task(task2)
    project.checklist = checklist
    c.add_project(project)
    assert_equal checklist, project.checklist
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_40_tasks_know_what_project_they_belong_to
    project = Project.new
    checklist = Checklist.new
    task = Task.new
    checklist.add_task(task)
    task.project = project
    assert_equal project, task.project
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_41_task_projects_are_set_when_checklist_is_added_to_project
    project = Project.new
    checklist = Checklist.new
    task = Task.new
    checklist.add_task(task)
    project.checklist = checklist
    assert_equal project, task.project
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end

  def test_42_tasks_can_be_marked_as_complete
    project = Project.new
    checklist = Checklist.new
    task = Task.new
    checklist.add_task(task)
    project.checklist = checklist
    task.status = :complete
    assert_equal :complete, task.status
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_43_num_complete_returns_number_of_complete_tasks
    checklist = Checklist.new
    task = Task.new
    task2 = Task.new
    task3 = Task.new
    checklist.add_task(task)
    checklist.add_task(task2)
    checklist.add_task(task3)
    task.status = :complete
    assert_equal 1, checklist.num_complete
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_44_percent_complete_returns_percent_of_completed_tasks
    checklist = Checklist.new
    task = Task.new
    task2 = Task.new
    task3 = Task.new
    task4 = Task.new
    checklist.add_task(task)
    checklist.add_task(task2)
    checklist.add_task(task3)
    checklist.add_task(task4)
    task.status = :complete
    assert_equal 0.25, checklist.percent_complete
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_45_remove_task_removes_task_from_projects_array
    checklist = Checklist.new
    task = Task.new
    task2 = Task.new
    task3 = Task.new
    checklist.add_task(task)
    checklist.add_task(task2)
    checklist.add_task(task3)
    checklist.remove_task(task3)
    assert_equal false, checklist.projects.include?(task3)
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
    File.open('lib/tasks_archive.csv', 'w') { |file| file.truncate(0) }
  end
  def test_46_task_have_time_estimate
    task = Task.new
    time = Time.local(2012, 3, 2)
    task.start_time =  time
    task.time_estimate= 3
    assert_equal 3, task.time_estimate
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_47_time_estimate_calculates_deadline
    task = Task.new
    time = Time.local(2012, 3, 2)
    task.start_time =  time
    task.time_estimate= 3
    assert_equal time + (3 * DAY), task.deadline
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_48_time_estimate_recalculate_deadline_if_start_time_is_changed
    task = Task.new
    time = Time.local(2012, 3, 2)
    task.time_estimate= 3
    task.start_time =  time
    assert_equal time + (3 * DAY), task.deadline
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_49_task_can_have_dependent_tasks
    task = Task.new
    task2 = Task.new
    task.dependent_task = task2
    assert_equal task2 , task.dependent_task
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_50_dependent_tasks_start_on_deadline_of_parent_task
    task = Task.new
    time = Time.local(2012, 3, 2)
    task.time_estimate= 3
    task.start_time =  time
    task2 = Task.new
    task.dependent_task = task2
    assert_equal time + (3 * DAY) , task2.start_time
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_51_dependent_tasks_start_on_deadline_of_parent_task
    task = Task.new
    time = Time.local(2012, 3, 2)
    task.time_estimate= 3
    task.start_time =  time
    task2 = Task.new
    checklist = Checklist.new
    checklist.add_task(task)
    checklist.add_task(task2)
    task.dependent_task = task2
    assert_equal time + (3 * DAY) , task2.start_time
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_52_dependent_tasks_can_be_set_to_nil
    task = Task.new
    time = Time.local(2012, 3, 2)
    task.time_estimate= 3
    task.start_time =  time
    task2 = Task.new
    task3 = Task.new
    checklist = Checklist.new
    checklist.add_task(task)
    checklist.add_task(task2)
    checklist.add_task(task3)
    task.dependent_task = task2
    task.dependent_task = nil
    assert_equal nil , task.dependent_task
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end
  def test_53_dependent_tasks_can_be_set_to_nil
    task = Task.new
    time = Time.local(2012, 3, 2)
    task.time_estimate= 3
    task.start_time =  time
    task2 = Task.new
    task2.time_estimate = 3
    task3 = Task.new
    task3.time_estimate = 3
    checklist = Checklist.new
    checklist.add_task(task)
    checklist.add_task(task2)
    checklist.add_task(task3)
    task.dependent_task = task2
    task2.dependent_task = task3
    assert_equal 9, checklist.dependent_time_span
    File.open('lib/tasks.csv', 'w') { |file| file.truncate(0) }
  end

end


















