require_dependency 'project'

module RedmineResponsibilityList
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        unloadable
        has_many :membership_histories
      end
    end
  end
end
