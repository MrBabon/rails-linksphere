class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :phone, :string
    add_column :users, :job, :string
    add_column :users, :biography, :text
    add_column :users, :industry, :string
    add_column :users, :website, :string
    add_column :users, :linkedin, :string
    add_column :users, :instagram, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
  end
end
