class LoadOrdinals < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :load_ordinal, :integer
    add_index :orders, [:load_truck_id, :load_date, :load_ordinal, :load_shift], :unique => true, :name => 'uq_order_load', :where => 'load_truck_id IS NOT null'
  end
end
