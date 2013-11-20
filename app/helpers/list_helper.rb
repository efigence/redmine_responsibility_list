module ListHelper

  def multiple_user_link(user_logins)
    return nil if user_logins.empty?
    str = ''
    user_logins.each_with_index do |login, i|
      user = User.find_by_login(login)
      str << link_to("#{user.name} (#{user.login})", user_path(user))
      str << ', ' unless i == user_logins.size - 1
    end
    str.html_safe
  end
end
