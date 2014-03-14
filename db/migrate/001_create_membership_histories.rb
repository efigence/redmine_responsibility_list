class CreateMembershipHistories < ActiveRecord::Migration
  def change
    create_table :membership_histories do |t|

      t.integer :project_id, null: false
      t.integer :user_id,    null: false
      t.integer :role_id,    null: false
      t.boolean :given,      null: false
    end
    add_index :membership_histories, :project_id
    add_index :membership_histories, :user_id
    add_index :membership_histories, :role_id
  end
end
