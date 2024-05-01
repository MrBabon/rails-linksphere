class CreateContactGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_groups do |t|
      t.string :name
      t.boolean :deletable
      t.references :repertoire, null: false, foreign_key: true

      t.timestamps
    end
  end
end
