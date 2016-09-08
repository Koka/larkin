class AdditionalIndices < ActiveRecord::Migration[5.0]
  def change
    remove_index :orders, :delivery_date
    add_index :orders, :parsed_delivery_date
    add_index :orders, :cancelled
    remove_index :trucks, :driver_id
    add_index :trucks, :driver_id, :unique => true
  end
end
