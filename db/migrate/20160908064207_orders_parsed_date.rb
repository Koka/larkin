class OrdersParsedDate < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :parsed_delivery_date, :date
    Order.where('parsed_delivery_date is null').where("delivery_date SIMILAR TO '(0?[1-9]|1[012])[/-](0?[1-9]|[12][0-9]|3[01])[/-][12][0-9]{3}'").update_all("parsed_delivery_date = to_date(delivery_date, 'MM/DD/YYYY')")
  end
end
