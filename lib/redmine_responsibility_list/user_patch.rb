require_dependency 'user'

module RedmineResponsibilityList
  module UserPatch
    def self.included(base)
      base.class_eval do
        unloadable
        base.send(:include, InstanceMethods)
        has_many :membership_histories
      end
    end
    module InstanceMethods
      def fullname_with_login
        "#{firstname} #{lastname} (#{login})"
      end
    end
  end
end
