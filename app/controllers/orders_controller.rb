require 'csv'

class OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    query = Order.order(
      "coalesce(load_date, to_date(delivery_date, 'MM/DD/YYYY')) DESC",
      "(case coalesce(load_shift, delivery_shift) when 'M' then 0 when 'N' then 1 when 'E' then 2 else -1 end) DESC",
      :client_name
    )

    query = query.where(cancelled: false).or(query.where(cancelled: nil)) if (params[:cancelled] == 'false')
    query = query.where(cancelled: true) if (params[:cancelled] == 'true')

    query = query.where(load_truck_id: nil) if (params[:completed] == 'false')
    query = query.where.not(load_truck_id: nil) if (params[:completed] == 'true')

    query = query.where("to_date(delivery_date, 'MM/DD/YYYY') >= current_date") if (params[:outdated] == 'false')
    query = query.where.not("to_date(delivery_date, 'MM/DD/YYYY') >= current_date") if (params[:outdated] == 'true')

    render json: query
  end

  def show
    render json: Order.find_by(id: params[:id])
  end

  def update
    order = Order.find(params[:id])
    order.update_attributes!(params.require(:order).permit!)
    render json: Order.find_by(id: params[:id])
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
