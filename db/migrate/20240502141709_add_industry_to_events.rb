class AddIndustryToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :industry, :string
  end
end
