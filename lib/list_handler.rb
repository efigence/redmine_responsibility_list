class ListHandler

  attr_reader :roles, :custom_fields
  attr_accessor :open_list, :closed_list, :archived_list

  def initialize
    @open_list, @closed_list, @archived_list = [], [], []
    @roles = Setting.plugin_redmine_responsibility_list[:roles].map { |_,v| v[:title] }
    @custom_fields = get_custom_fields
    @code_name = CustomField.find_by_name("Code name")
  end

  def generate
    Project.where(status: 1).each { |project| @open_list     << get_data_for(project) }
    Project.where(status: 5).each { |project| @closed_list   << get_data_for(project) }
    Project.where(status: 9).each { |project| @archived_list << get_data_for(project) }

    { open: @open_list.compact, closed: @closed_list.compact, archived: @archived_list.compact }
  end

  private

  def get_data_for(project)
    return if CustomField.find_by_name("Responsibility list").custom_values.where(customized_id: project.id).first.try(:value) != "1"
    @project = project
    data = { name: project.name, page: project.homepage, code_name: get_code_name }

    @custom_fields.each do |field|
      value = field.custom_values.where(customized_id: project.id).first.try(:value)
      data[field.name] = field.field_format == 'bool' ? value == '1' : value
    end

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

  def get_code_name
    value = @code_name ? @code_name.custom_values.where(customized_id: @project.id).first.try(:value) : nil
    if value && !value.blank?
      value
    else
      @project.identifier
    end
  end

  def get_custom_fields
    arr = []
    if !Setting.plugin_redmine_responsibility_list[:custom_fields].blank?
      Setting.plugin_redmine_responsibility_list[:custom_fields].each do |id|
        cf = CustomField.find_by_id(id.to_i)
        arr << cf if cf
      end
    end
    arr
  end
end
