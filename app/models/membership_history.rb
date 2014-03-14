class MembershipHistory < ActiveRecord::Base
  unloadable

  attr_accessible :role_id, :user_id, :project_id, :given

  belongs_to :user
  belongs_to :project
end
