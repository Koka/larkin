class RemoveTripsPerDay < ActiveRecord::Migration[5.0]
  def change
    remove_column :trucks, :trips_per_day
  end
end
