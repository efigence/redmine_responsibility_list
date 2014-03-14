require_dependency 'user'

module RedmineResponsibilityList
  module UserPatch
    def self.included(base)
      base.class_eval do
        unloadable
        has_many :membership_histories
      end
    end
  end
end
