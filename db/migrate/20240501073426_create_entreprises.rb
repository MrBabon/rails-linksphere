class CreateEntreprises < ActiveRecord::Migration[7.0]
  def change
    create_table :entreprises do |t|
      t.string :name
      t.string :email
      t.string :website
      t.string :linkedin
      t.string :instagram
      t.string :facebook
      t.string :twitter
      t.string :headline
      t.string :industry
      t.text :description
      t.string :siret
      t.string :tva
      t.string :address
      t.string :phone
      t.datetime :establishment
      t.string :legal_status
      t.float :latitude
      t.float :longitude
      t.string :country
      t.string :city
      t.string :region

      t.timestamps
    end
  end
end
