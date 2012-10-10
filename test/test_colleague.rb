require 'test/unit'
require 'colleague'
require 'project'
require 'client'
require 'constants'

class ColleagueTest < Test::Unit::TestCase
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
  end
end