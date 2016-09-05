class RenameUglyRawlineField < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :destination_raw_line_1, :destination_address
    rename_column :orders, :origin_raw_line_1, :origin_address
  end
end
