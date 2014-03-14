class AddTimestampsToMembershipHistories < ActiveRecord::Migration
  def change
    add_column(:membership_histories, :created_at, :datetime)
    add_column(:membership_histories, :updated_at, :datetime)
  end
end
