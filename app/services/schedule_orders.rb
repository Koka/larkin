class ScheduleOrders
  def self.build
    new
  end

  def call(truck_id, shift, date, order_ids)
    truck = Truck.find truck_id
    orders = Order.order_as_specified(id: order_ids).find order_ids
    Order.transaction do
      orders.each do |order|
        order.schedule! truck, date, shift
      end
    end
  end
end
