class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :delivery_date
      t.string :delivery_shift
      t.string :origin_name
      t.string :origin_raw_line_1
      t.string :origin_city
      t.string :origin_state
      t.string :origin_zip
      t.string :origin_country
      t.string :client
      t.string :name
      t.string :destination_raw_line_1
      t.string :destination_city
      t.string :destination_state
      t.string :destination_zip
      t.string :destination_country
      t.string :phone_number
      t.string :mode
      t.string :purchase_order_number
      t.string :volume
      t.string :handling_unit_quantity
      t.string :handling_unit_type

      t.timestamps
    end
  end
end
