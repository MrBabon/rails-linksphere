class RemoveContactGroupIdFromUserContactGroups < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_contact_groups, :contact_group_id, :bigint
  end
end
