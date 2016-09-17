class ScheduleOrders
  def self.build
    new
  end

  def call(truck, shift, date, order_ids)
    Order.transaction do
      order_ids.each do |id|
        order = Order.find id
        order.schedule! Truck.find(truck), date, shift
      end
    end
  end
end
