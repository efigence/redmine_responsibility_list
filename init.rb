require 'redmine'

Redmine::Plugin.register :redmine_responsibility_list do
  name 'Redmine Responsibility List plugin'
  author 'Jacek Grzybowski'
  description 'Plugin allowing to create responsibility list for existing projects'
  version '0.0.1'

  menu :top_menu, :responsibility_list,
    { :controller => 'list', :action => 'index' },
    :caption => 'Responsibility list',
    :last => true, :if => proc {
      User.current.admin? ||
      !(User.current.groups.select('id').collect{|el| el.id.to_s} & Setting.plugin_redmine_responsibility_list[:groups]).blank? }


  settings :default => {
    roles: {
      :role1 => { title: 'Project Manager', names: ['Project Manager'] },
      :role2 => { title: 'Architect',       names: ['Application architect'] },
      :role3 => { title: 'Vice architect',  names: ['Vice-Architect'] },
      :role4 => { title: 'Developers',      names: ['Developer'] },
      :role5 => { title: 'Front End',       names: ['Frontend Developer'] }
    }, auth_key: '123456'
  }, :partial => 'settings/responsibility_settings'
end
