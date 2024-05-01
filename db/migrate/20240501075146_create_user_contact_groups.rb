class CreateUserContactGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :user_contact_groups do |t|
      t.text :personal_note
      t.references :contact_group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
