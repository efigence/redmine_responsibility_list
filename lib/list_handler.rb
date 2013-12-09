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
    return if CustomField.find_by_name("Responsibility list").
          custom_values.where(customized_id: project.id).first.try(:value) != "1"
    @project = project
    @users_with_roles = users_with_roles
    get_all_data
    @data
  end

  def users_with_roles
    user_roles = {}
    @project.users_by_role.sort.each_with_index do |user_role, i|
      user_roles[user_role[0].name] = user_role[1].map(&:login)
    end
    user_roles
  end

  def get_code_name
    value = @code_name ? @code_name.custom_values.where(customized_id: @project.id).first.try(:value) : nil
    !value.blank? ? value : @project.identifier
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

  def assign_basic_data
    @data = { name: @project.name, page: @project.homepage, code_name: get_code_name }
    @roles.each { |role| @data[role] = [] }
  end

  def assign_custom_data
    @custom_fields.each do |field|
      value = field.custom_values.where(customized_id: @project.id).first.try(:value)
      @data[field.name] = field.field_format == 'bool' ? value == '1' : value
    end
  end

  def assign_role_data
    Setting.plugin_redmine_responsibility_list[:roles].each_with_index do |(k,_), i|
      Setting.plugin_redmine_responsibility_list[:roles][k][:names].try :each do |role_name|
        @data[@roles[i]] += @users_with_roles[role_name] unless @users_with_roles[role_name].nil?
      end
      @data[@roles[i]].uniq!
    end
  end

  def get_all_data
    assign_basic_data
    assign_custom_data
    assign_role_data
  end
end
