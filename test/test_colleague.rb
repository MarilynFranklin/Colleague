require 'test/unit'
require 'colleague'
require 'project'
require 'client'
require 'constants'
require 'project_file'
require 'client_manager'

class ColleagueTest < Test::Unit::TestCase
  include Project_file
#==============project object attributes================#
  def test_01_project_must_have_title
    project = Project.new("my great project")
    assert_equal "my great project", project.title
  end
  def test_02_project_exists
    project = Project.new("great title")
    assert_equal Project, project.class
  end
  def test_03_project_default_status_is_incomplete
    project = Project.new("great title")
    assert_equal :incomplete, project.status
  end
  def test_04_can_set_project_type
    project = Project.new("great title")
    project.type = "web design"
    assert_equal "web design", project.type
  end
  def test_04b_can_set_project_type
    project = Project.new("great title")
    project.type = "logo"
    assert_equal "logo", project.type
  end
  def test_05_can_add_project_notes
    project = Project.new("great title")
    project.notes = "remember this!"
    assert_equal "remember this!", project.notes
  end
  def test_06_projects_should_set_start_time_automatically
    project = Project.new("great title")
    assert_equal Time.now.hour, project.start_time.hour
  end
  def test_06b_user_can_change_start_time
    project = Project.new("great title")
    time = Time.local(2012, 3, 2)
    project.start_time = time
    assert_equal time, project.start_time
  end
  def test_07_can_set_project_deadline
    project = Project.new("great title")
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
    project = Project.new("title")
    project.client= client
    assert_equal "Jane Smith", project.client
  end
  def test_14_project_can_set_client
    client = Client.new
    client.first_name = "Jane"
    project = Project.new("title")
    project.client= client
    assert_equal "Jane ", project.client
  end
#==============project object operations================#
  def test_15_can_set_project_as_complete
    project = Project.new("title")
    project.status= :complete
    assert_equal :complete, project.status
  end
  def test_16_time_till_due_is_correct
    project = Project.new("title")
    project.deadline= Time.now + (3 * DAY)
    assert_equal true, project.time_till_due <= (3 * DAY) && project.time_till_due > (2 * DAY)
  end
  def test_17_time_till_due_is_correct
    project = Project.new("title")
    project.deadline= Time.now + (4 * DAY)
    assert_equal false, project.time_till_due == (3 * DAY)
  end
  def test_18_is_urgent_returns_true_if_one_day_from_now
    project = Project.new("title")
    project.deadline= Time.now + DAY
    assert_equal true, project.is_urgent?
  end
  def test_19_is_due_soon_returns_true_if_due_between_3_and_1_day
    project = Project.new("title")
    project.deadline= Time.now + (2 * DAY)
    assert_equal true, project.is_due_soon?
  end
  def test_20_is_due_later_returns_true_when_greater_than_3_days_away
    project = Project.new("title")
    project.deadline= Time.now + (3.5 * DAY)
    assert_equal true, project.is_due_later?
  end
#==============colleague object tests================#
  def test_21_colleague_is_object
    proj_manager = Colleague.new
    assert_equal Colleague, proj_manager.class
  end
  
  def test_22_colleague_keeps_track_of_num_projects_ever_created
    proj_manager = Colleague.new
    assert_equal 0, proj_manager.num_projects
  end

  def test_23_colleague_keeps_track_of_num_projects_ever_created
    proj_manager = Colleague.new
    project = Project.new("first")
    project2 = Project.new("second")
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    assert_equal 2, proj_manager.num_projects
    File.open('lib/projects.csv', 'w') {|file| file.truncate(0) }
  end

  def test_24_colleague_adds_project_to_file
    proj_manager = Colleague.new
    project = Project.new("great title")
    jane_doe = Client.new
    project.start_time = Time.local(2012, 10, 9, 22, 53,57)
    project.deadline = Time.local(2012,10,10, 22,53,57)
    project.notes = "notes"
    jane_doe.first_name = "Jane"
    jane_doe.last_name = "Doe"
    project.type = 'web design'
    project.client = jane_doe
    proj_manager.add_project(project)
    lines = []
    file = File.open('lib/projects.csv', 'r')
    while (line = file.gets) do 
      lines << line
    end
    file.close
    assert_equal lines[0].to_s, "1,great title,2012-10-10 22:53:57 -0500,web design,2012-10-09 22:53:57 -0500,notes,incomplete,Jane Doe\n"
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end 

  def test_25_colleague_adds_project_to_file
    proj_manager = Colleague.new
    project = Project.new("great title")
    project2 = Project.new("another great title")
    jane_doe = Client.new
    john_doe = Client.new
    project.start_time = Time.local(2012, 10, 9, 22, 53,57)
    project.deadline = Time.local(2012,10,10, 22,53,57)
    project.notes = "notes"
    jane_doe.first_name = "Jane"
    jane_doe.last_name = "Doe"
    project.type = 'web design'
    project.client = jane_doe
    project2.start_time = Time.local(2012, 10, 9, 22, 53,57)
    project2.deadline = Time.local(2012,10,20, 22,53,57)
    project2.notes = "remember"
    john_doe.first_name = "John"
    john_doe.last_name = "Doe"
    project2.type = 'web development'
    project2.client = jane_doe
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    lines = []
    file = File.open('lib/projects.csv', 'r')
    while (line = file.gets) do 
      lines << line
    end
    file.close
    assert_equal lines.each{ |line| line.to_s }, ["1,great title,2012-10-10 22:53:57 -0500,web design,2012-10-09 22:53:57 -0500,notes,incomplete,Jane Doe\n",
                                                  "2,another great title,2012-10-20 22:53:57 -0500,web development,2012-10-09 22:53:57 -0500,remember,incomplete,Jane Doe\n"]
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end 

  def test_26_colleague_adds_project_to_file
    proj_manager = Colleague.new
    project = Project.new("great title")
    project.start_time = Time.local(2012, 10, 9, 22, 53, 57)
    proj_manager.add_project(project)
    lines = []
    file = File.open('lib/projects.csv', 'r')
    while (line = file.gets) do 
      lines << line
    end
    file.close
    assert_equal lines.each{ |line| line.to_s }, ["1,great title,,,2012-10-09 22:53:57 -0500,,incomplete,\n"]
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end  

  def test_27_colleague_sets_project_id_to_match_num_projects
    proj_manager = Colleague.new
    project = Project.new("great title")
    proj_manager.add_project(project)
    assert_equal 1, project.id
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end 
  def test_27b_colleague_sets_project_id_to_match_num_projects
    proj_manager = Colleague.new
    project = Project.new("great title")
    project2 = Project.new("another great title")
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    assert_equal 2, project2.id
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end 
#==============Module tests================#
  def test_27c_Module_reads_file
    proj_manager = Colleague.new
    project = Project.new("great title")
    project2 = Project.new("another great title")
    jane_doe = Client.new
    john_doe = Client.new
    project.start_time = Time.local(2012, 10, 9, 22, 53,57)
    project.deadline = Time.local(2012,10,10, 22,53,57)
    project.notes = "notes"
    jane_doe.first_name = "Jane"
    jane_doe.last_name = "Doe"
    project.type = 'web design'
    project.client = jane_doe
    project2.start_time = Time.local(2012, 10, 9, 22, 53,57)
    project2.deadline = Time.local(2012,10,20, 22,53,57)
    project2.notes = "remember"
    john_doe.first_name = "John"
    john_doe.last_name = "Doe"
    project2.type = 'web development'
    project2.client = jane_doe
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    assert_equal read, [{:id => "1",:title => "great title",:deadline => "2012-10-10 22:53:57 -0500",:type => "web design",:start => "2012-10-09 22:53:57 -0500",:notes => "notes",:status => "incomplete",:client => "Jane Doe\n"},
                        {:id => '2',:title => "another great title",:deadline => "2012-10-20 22:53:57 -0500",:type => "web development",:start => "2012-10-09 22:53:57 -0500",:notes => "remember",:status => "incomplete",:client => "Jane Doe\n"}]
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end
  def test_27d_Module_changes_start_time_after_project_added_to_file
    proj_manager = Colleague.new
    project = Project.new("great title")
    project2 = Project.new("another great title")
    project.start_time = Time.local(2012, 10, 9, 22, 53,57)
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    project2.start_time = Time.local(2012, 10, 9, 22, 53,57)

    assert_equal read, [{:id => "1",:title => "great title",:deadline => "",:type => "",:start => "2012-10-09 22:53:57 -0500",:notes => "",:status => 'incomplete',:client => "\n"},
                        {:id => "2",:title => "another great title",:deadline => "",:type => "",:start => "2012-10-09 22:53:57 -0500",:notes => "",:status => "incomplete",:client => "\n"}]
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_27e_Module_changes_start_time_after_project_added_to_file
    proj_manager = Colleague.new
    project = Project.new("great title")
    project2 = Project.new("another great title")
    project.start_time = Time.local(2012, 10, 9, 22, 53,57)
    proj_manager.add_project(project)
    proj_manager.add_project(project2)
    project2.start_time = Time.local(2012, 10, 9, 22, 53,57)

    assert_equal project2.start_time.to_s, "2012-10-09 22:53:57 -0500"
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_28_can_change_project_attributes_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    project.start_time = Time.local(2012, 10, 9, 22, 53, 57)
    proj_manager.add_project(project)
    project.deadline = Time.local(2012,10,10, 22,53,57)
    lines = []
    file = File.open('lib/projects.csv', 'r')
    while (line = file.gets) do 
      lines << line
    end
    file.close
    assert_equal lines.each{ |line| line.to_s }, ["1,great title,2012-10-10 22:53:57 -0500,,2012-10-09 22:53:57 -0500,,incomplete,\n"]
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_29_can_change_project_attributes_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    project.start_time = Time.local(2012, 10, 9, 22, 53, 57)
    proj_manager.add_project(project)
    project.deadline = Time.local(2012,10,10, 22,53,57)
    project.notes = "notes"
    project.type = 'web design'
    project.status = :complete
    project.title = "new title"
    lines = []
    file = File.open('lib/projects.csv', 'r')
    while (line = file.gets) do 
      lines << line
    end
    file.close
    assert_equal lines.each{ |line| line.to_s }, ["1,new title,2012-10-10 22:53:57 -0500,web design,2012-10-09 22:53:57 -0500,notes,complete,\n"]
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_30_can_change_project_title_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    proj_manager.add_project(project)
    project.title = "new title"
    assert_equal "new title", project.title
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_31_can_change_project_status_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    proj_manager.add_project(project)
    project.status = :complete
    assert_equal :complete, project.status
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_32_can_change_project_type_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    proj_manager.add_project(project)
    project.type = "web development"
    assert_equal "web development", project.type
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_33_can_change_project_notes_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    proj_manager.add_project(project)
    project.notes = "important"
    assert_equal "important", project.notes
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_34_can_change_project_client_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    project.start_time = Time.local(2012, 10, 9, 22, 53, 57)
    proj_manager.add_project(project)
    client2 = Client.new
    client2.first_name = "Glen"
    client2.last_name = "Stevens"
    project.client = client2
    lines = []
    file = File.open('lib/projects.csv', 'r')
    while (line = file.gets) do 
      lines << line
    end
    file.close
    assert_equal lines.each{ |line| line.to_s }, ["1,great title,,,2012-10-09 22:53:57 -0500,,incomplete,Glen Stevens\n"]
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_35_can_change_project_client_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    proj_manager.add_project(project)
    client2 = Client.new
    client2.first_name = "Glen"
    client2.last_name = "Stevens"
    project.client = client2
    assert_equal "Glen Stevens", project.client
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

  def test_36_can_change_project_client_name_after_added_to_colleague
    proj_manager = Colleague.new
    project = Project.new("great title")
    proj_manager.add_project(project)
    client2 = Client.new
    client2.first_name = "Glen"
    client2.last_name = "Stevens"
    project.client = client2
    client2.first_name = "Sam"
    assert_equal "Sam Stevens", project.client
    File.open('lib/projects.csv', 'w') { |file| file.truncate(0) }
  end

end


















