class ListHandler

  attr_reader :roles, :custom_field
  attr_accessor :open_list, :closed_list, :archived_list

  def initialize
    @open_list, @closed_list, @archived_list = [], [], []
    @roles = Setting.plugin_redmine_responsibility_list[:roles].map { |k,v| v[:title] }
    @custom_field = custom_field_val
  end

  def generate
    Project.where(status: 1).each { |project| @open_list     << get_data_for(project) }
    Project.where(status: 5).each { |project| @closed_list   << get_data_for(project) }
    Project.where(status: 9).each { |project| @archived_list << get_data_for(project) }

    { open: @open_list, closed: @closed_list, archived: @archived_list }
  end

  private

  def custom_enabled?
    !Setting.plugin_redmine_responsibility_list[:custom_field].blank?
  end

  def custom_field_val
    custom_enabled? ? CustomField.find(Setting.plugin_redmine_responsibility_list[:custom_field]) : nil
  end

  def get_data_for(project)
    data = { name: project.name, identifier: project.identifier, page: project.homepage }

    data[@custom_field.name] = @custom_field.custom_values.where(customized_id: project.id).
          first.try(:value) == '1' ? true : false if @custom_field

    @roles.each { |role| data[role] = [] }

    Setting.plugin_redmine_responsibility_list[:roles].each_with_index do |(k,v), i|
      Setting.plugin_redmine_responsibility_list[:roles][k][:names].try :each do |role_name|
        current_role = Role.find_by_name(role_name)
        data[@roles[i]] += project.users_by_role[current_role].select('login').map(&:login) if project.users_by_role[current_role]
      end
      data[@roles[i]].uniq!
    end
    data
  end
end
