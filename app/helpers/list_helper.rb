module ListHelper

  def multiple_user_link(user_logins)
    return nil if user_logins.empty?
    str = ''
    users = User.select([:id, :login, :firstname, :lastname]).where(login: user_logins)
    users.each do |user|
      str << link_to("#{user.to_s} (#{user.login})", user_path(user))
      str << ', ' unless users.last == user
    end
    str.html_safe
  end
end
