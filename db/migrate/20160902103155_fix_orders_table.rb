class FixOrdersTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :name
    rename_column :orders, :client, :client_name
  end
end
