class CreateEntrepriseContactGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :entreprise_contact_groups do |t|
      t.references :repertoire, null: false, foreign_key: true
      t.references :entreprise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
