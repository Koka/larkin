require 'csv'

class OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    query = Order.order(
      "coalesce(load_date, parsed_delivery_date) DESC",
      "(case coalesce(load_shift, delivery_shift) when 'M' then 0 when 'N' then 1 when 'E' then 2 else -1 end) DESC",
      :client_name
    )

    query = query.where(cancelled: false).or(query.where(cancelled: nil)) if (params[:cancelled] == 'false')
    query = query.where(cancelled: true) if (params[:cancelled] == 'true')

    query = query.where(load_truck_id: nil) if (params[:completed] == 'false')
    query = query.where.not(load_truck_id: nil) if (params[:completed] == 'true')

    query = query.where("load_date >= current_date") if (params[:pending] == 'true')
    query = query.where("load_date IS NULL OR load_date < current_date") if (params[:pending] == 'false')

    query = query.where("parsed_delivery_date >= current_date") if (params[:outdated] == 'false')
    query = query.where("parsed_delivery_date IS NULL OR parsed_delivery_date < current_date") if (params[:outdated] == 'true')

    render json: query
  end

  def show
    render json: Order.find_by(id: params[:id])
  end

  def schedule
    order = Order.find params[:id]

    result = ActiveRecord::Base.connection_pool.with_connection do |con|
      con.exec_query("
	       select max(coalesce(load_ordinal, 0)) + 1 as new_ordinal
          from orders
          where (load_truck_id, load_shift, load_date) = ($1, $2, $3)
        ",
        'Select new order load ordinal',
        [
          bind_value('truck', :integer, params[:truck]),
          bind_value('shift', :string, params[:shift]),
          bind_value('date', :date, Date.parse(params[:date]))
        ]
      )
    end

    new_ordinal = result[0] && result[0]["new_ordinal"] ? result[0]["new_ordinal"] : 0

    order.update_attributes!({
      load_truck: Truck.find(params[:truck]),
      load_date: Date.parse(params[:date]),
      load_shift: params[:shift],
      load_ordinal: new_ordinal
    })
  end

  def update
    order = Order.find(params[:id])
    order.update_attributes!(params.require(:order).permit!)
    render json: Order.find_by(id: params[:id])
  end

  def split
    Order.transaction do
      order = Order.find(params[:id])
      part = order.dup

      qty = order.handling_unit_quantity.to_i
      order.handling_unit_quantity = qty / 2
      part.handling_unit_quantity = qty - qty / 2

      vol = order.volume.to_f
      order.volume = vol / 2
      part.volume = vol - vol / 2

      order.save
      part.save
    end
  end

  def upload
    raise "expected text/csv file" unless params[:file].content_type == "text/csv"

    Order.transaction do
      CSV.foreach(params[:file].tempfile, { headers: true }) do |row|
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
