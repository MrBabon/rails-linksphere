class AddUniqueIndexToUserContactGroups < ActiveRecord::Migration[7.0]
  def change
    add_index :user_contact_groups, [:user_id, :current_user_id], unique: true, name: 'index_user_contact_groups_on_user_and_current_user'
  end
end
