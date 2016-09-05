class CreateTrucks < ActiveRecord::Migration[5.0]
  def change
    create_table :trucks do |t|
      t.string :name
      t.integer :trips_per_day
      t.integer :max_weight
      t.integer :max_volume
      t.references :user, foreign_key: true

      t.timestamps
    end

    rename_column :trucks, :user_id, :driver_id
  end
end
