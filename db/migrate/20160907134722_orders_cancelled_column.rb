class OrdersCancelledColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cancelled, :boolean
  end
end
