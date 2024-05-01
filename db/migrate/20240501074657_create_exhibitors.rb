class CreateExhibitors < ActiveRecord::Migration[7.0]
  def change
    create_table :exhibitors do |t|
      t.references :event, null: false, foreign_key: true
      t.references :entreprise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
