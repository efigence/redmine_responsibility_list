require 'list_handler'

class ListController < ApplicationController
  unloadable

  skip_before_filter :session_expiration, :user_setup, :check_if_login_required, :set_localization, if: :api_request?
  before_filter :permitted_or_api_request?

  def index
    @list_handler = ListHandler.new
    @full_list = @list_handler.generate

    respond_to do |format|
      format.html
      format.json { render :json => @full_list.to_json }
    end
  end

  def membership_list
    @memberships = MembershipHistory.order('created_at DESC')
  end

  private

  def permitted_or_api_request?
    deny_access unless api_request? && proper_auth_key? || User.current.admin? || has_access?
  end

  def proper_auth_key?
    # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.8
    request.headers['Authorization'] == Setting.plugin_redmine_responsibility_list[:auth_key]
  end

  def has_access?
    !(user_ids & groups_with_access).blank?
  end

  def user_ids
    User.current.groups.select('id').collect{|el| el.id.to_s}
  end

  def groups_with_access
    Setting.plugin_redmine_responsibility_list[:groups] || []
  end
end
