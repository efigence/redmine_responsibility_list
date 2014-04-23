require_dependency 'member_role'

module RedmineResponsibilityList
  module MemberRolePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        after_create   :record_added_membership
        before_destroy :record_deleted_membership
      end
    end

    module InstanceMethods
      def record_added_membership
        if member.user
          member.user.membership_histories.create(role_id: role_id,
                                                  project_id: member.project_id,
                                                  given: true)
        end
      end
      def record_deleted_membership
        if member.user
          member.user.membership_histories.create(role_id: role_id,
                                                  project_id: member.project_id,
                                                  given: false)
        end
      end
      private :record_added_membership, :record_deleted_membership
    end
  end
end
