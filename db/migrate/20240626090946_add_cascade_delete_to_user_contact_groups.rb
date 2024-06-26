class AddCascadeDeleteToUserContactGroups < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :user_contact_groups, :users
    add_foreign_key :user_contact_groups, :users, column: :user_id, on_delete: :cascade

    remove_foreign_key :user_contact_groups, column: :current_user_id if foreign_key_exists?(:user_contact_groups, column: :current_user_id)
    add_foreign_key :user_contact_groups, :users, column: :current_user_id, on_delete: :cascade
  end
end
