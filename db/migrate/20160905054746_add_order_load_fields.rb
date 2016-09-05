class AddOrderLoadFields < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :load_date, :date
    add_column :orders, :load_truck_id, :integer
    add_column :orders, :load_shift, :string
    add_foreign_key :orders, :trucks, column: :load_truck_id
    add_index :orders, :load_date
    add_index :orders, :load_truck_id
    add_index :orders, :load_shift
    add_index :orders, :delivery_date
  end
end
