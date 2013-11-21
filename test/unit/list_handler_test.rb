require File.expand_path('../../test_helper', __FILE__)

class ListHandlerTest < ActiveSupport::TestCase
  fixtures :users,
           :projects,
           :custom_fields,
           :roles,
           :members,
           :member_roles,
           :custom_values

   ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/../fixtures/',
                            [:users,
                             :projects,
                             :roles,
                             :members,
                             :member_roles,
                             :custom_fields,
                             :custom_values])

  def setup
    @handler = ListHandler.new

    Setting.plugin_redmine_responsibility_list = {
      roles: {
        :role1 => { title: 'Project Manager', names: ['Project Manager'] },
        :role2 => { title: 'Architect',       names: ['Application architect'] },
        :role3 => { title: 'Vice architect',  names: ['Vice-Architect'] },
        :role4 => { title: 'Developers',      names: ['Developer'] },
        :role5 => { title: 'Front End',       names: ['Frontend Developer'] }
      },
      auth_key: '123456',
      custom_field: '1'
    }
  end

  def test_new_instance_init_attributes
    assert_equal [], @handler.open_list
    assert_equal [], @handler.closed_list
    assert_equal [], @handler.archived_list

    assert_equal ["Project Manager", "Architect", "Vice architect", "Developers", "Front End"], @handler.roles

    assert_equal CustomField.first, @handler.custom_field
  end

  def test_proper_list_generation
    assign_projects
    create_comparison_data
    @list = @handler.generate

    assert_equal @open_list, @list[:open]
    assert_equal @closed_list, @list[:closed]
    assert_equal @archived_list, @list[:archived]
  end

  def test_list_generation_with_roles_assigned_to_multiple_role_titles
    Setting.plugin_redmine_responsibility_list[:roles]['role4'][:names] = ['Developer', 'Frontend Developer', 'Application architect']
    assign_projects
    comparison_data_multiple_roles
    @list = @handler.generate

    assert_equal @open_list, @list[:open]
    assert_equal @closed_list, @list[:closed]
    assert_equal @archived_list, @list[:archived]
  end

  private

  def assign_projects
    @project1 = Project.first
    @project2 = Project.find(2)
    @project3 = Project.find(3)
    @project4 = Project.find(4)
  end

  def create_comparison_data
    @open_list = [
      {
        name: @project1.name,
        identifier: @project1.identifier,
        page: @project1.homepage,
        'Personal Data' => true,
        'Project Manager' => [users(:mwallace).login, users(:admin).login],
        'Architect' => [users(:jlocke).login],
        'Vice architect' => [],
        'Developers' => [users(:jsmith).login],
        'Front End' => []
      },
      {
        name: @project2.name,
        identifier: @project2.identifier,
        page: @project2.homepage,
        'Personal Data' => false,
        'Project Manager' => [],
        'Architect' => [],
        'Vice architect' => [User.find(3).login],
        'Developers' => [User.find(1).login],
        'Front End'=> [User.find(2).login]
      }
    ]

    @closed_list = [
      {
        name: @project3.name,
        identifier: @project3.identifier,
        page: @project3.homepage,
        'Personal Data' => true,
        'Project Manager' => [User.find(4).login, User.find(3).login],
        'Architect' => [User.first.login],
        'Vice architect' => [],
        'Developers' => [],
        'Front End' => []
      }
    ]

    @archived_list = [
      {
        name: @project4.name,
        identifier: @project4.identifier,
        page: @project4.homepage,
        'Personal Data' => false,
        'Project Manager' => [User.find(2).login],
        'Architect' => [User.first.login],
        'Vice architect' => [],
        'Developers' => [User.find(3).login, User.first.login],
        'Front End' => [User.find(4).login]
      }
    ]
  end

  def comparison_data_multiple_roles
    create_comparison_data
    @open_list[0]['Developers'] = [users(:jsmith).login, users(:jlocke).login]
    @open_list[1]['Developers'] = [User.find(1).login, User.find(2).login]
    @closed_list[0]['Developers'] = [User.first.login]
    @archived_list[0]['Developers'] = [User.find(3).login, User.first.login, User.find(4).login]
  end
end
