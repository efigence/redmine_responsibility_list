class ListHandler

  attr_reader :roles, :custom_field
  attr_accessor :open_list, :closed_list, :archived_list

  def initialize
    @open_list, @closed_list, @archived_list = [], [], []
    @roles = Setting.plugin_redmine_responsibility_list[:roles].map { |_,v| v[:title] }
    @custom_field = requested_custom_field
  end

  def generate
    Project.where(status: 1).each { |project| @open_list     << get_data_for(project) }
    Project.where(status: 5).each { |project| @closed_list   << get_data_for(project) }
    Project.where(status: 9).each { |project| @archived_list << get_data_for(project) }

    { open: @open_list, closed: @closed_list, archived: @archived_list }
  end

  private

  def get_data_for(project)
    data = { name: project.name, identifier: project.identifier, page: project.homepage }

    data[@custom_field.name] = check_custom_value(project) if @custom_field

    @roles.each { |role| data[role] = [] }

    Setting.plugin_redmine_responsibility_list[:roles].each_with_index do |(k,_), i|
      Setting.plugin_redmine_responsibility_list[:roles][k][:names].try :each do |role_name|
        current_role = Role.find_by_name(role_name)
        data[@roles[i]] += project.users_by_role[current_role].map(&:login) if project.users_by_role[current_role]
      end
      data[@roles[i]].uniq!
    end
    data
  end

  def requested_custom_field
    CustomField.find_by_id(Setting.plugin_redmine_responsibility_list[:custom_field])
  end

  def check_custom_value(project)
    @custom_field.custom_values.where(customized_id: project.id).first.try(:value) == '1'
  end
end
