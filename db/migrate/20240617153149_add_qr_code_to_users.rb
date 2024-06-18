class AddQrCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :qr_code, :text
  end
end
