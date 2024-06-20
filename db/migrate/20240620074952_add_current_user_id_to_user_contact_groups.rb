class AddCurrentUserIdToUserContactGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :user_contact_groups, :current_user_id, :integer
    add_foreign_key :user_contact_groups, :users, column: :current_user_id
    add_index :user_contact_groups, :current_user_id
  end
end
