class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :city
      t.string :country
      t.string :region
      t.string :link
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :registration_code
      t.boolean :is_published, default: false, null: false
      t.references :entreprise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
