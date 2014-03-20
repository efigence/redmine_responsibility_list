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

  def render_membership_icon(membership)
    if membership.given
      "<img src='/images/toggle_check.png' title='role given' alt='role given'>".html_safe
    else
      "<img src='/images/locked.png' title='role taken away' alt='role taken away'>".html_safe
    end
  end

  def select_with_caption(name, caption, option_tags = nil, opts = {})
    select_opts = "<option value=''>#{caption}</option>".html_safe + option_tags
    select_tag(name, select_opts, opts)
  end
end
