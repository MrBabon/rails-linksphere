class CreateEntrepreneurs < ActiveRecord::Migration[7.0]
  def change
    create_table :entrepreneurs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entreprise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
