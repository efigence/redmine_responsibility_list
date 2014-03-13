class CreateMembershipHistories < ActiveRecord::Migration
  def change
    create_table :membership_histories do |t|
      t.references :project
      t.references :user
      t.integer :role_id
      t.string :type
    end
    add_index :membership_histories, :project_id
    add_index :membership_histories, :user_id
  end
end
