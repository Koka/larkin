class ScheduleOrders
  def self.build
    new
  end

  def call(truck, shift, date, order_ids)
    Order.transaction do
      order_ids.each do |id|
        order = Order.find id
        order.update_attributes!({
          load_truck: Truck.find(truck),
          load_date: date,
          load_shift: shift
        })
      end
    end
  end
end
