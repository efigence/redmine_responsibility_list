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
        member.user.membership_histories.create(role_id: self.role_id,
                                                project_id: self.member.project_id,
                                                given: true)
      end
      def record_deleted_membership
        member.user.membership_histories.create(role_id: self.role_id,
                                                project_id: self.member.project_id,
                                                given: false)
      end
      private :record_added_membership, :record_deleted_membership
    end
  end
end
