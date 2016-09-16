require 'csv'

class UploadOrders
  def self.build
    new
  end

  def call(file)
    raise "expected text/csv file" unless file.content_type == "text/csv"

    Order.transaction do
      CSV.foreach(file.tempfile, { headers: true }) do |row|
        order = Order.new
        col = 0
        order.delivery_date = row[col]
        order.delivery_shift = row[col += 1]
        order.origin_name = row[col += 1]
        order.origin_address = row[col += 1]
        order.origin_city = row[col += 1]
        order.origin_state = row[col += 1]
        order.origin_zip = row[col += 1]
        order.origin_country = row[col += 1]
        order.client_name = row[col += 1]
        order.destination_address = row[col += 1]
        order.destination_city = row[col += 1]
        order.destination_state = row[col += 1]
        order.destination_zip = row[col += 1]
        order.destination_country = row[col += 1]
        order.phone_number = row[col += 1]
        order.mode = row[col += 1]
        order.purchase_order_number = row[col += 1]
        order.volume = row[col += 1]
        order.handling_unit_quantity = row[col += 1]
        order.handling_unit_type = row[col += 1]
        order.save()
      end
    end

  end

end
