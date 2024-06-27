class AddPreferencesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :push_notifications, :boolean, default: false
    add_column :users, :messages_from_contacts, :boolean, default: false
    add_column :users, :messages_from_everyone, :boolean, default: false
  end
end
