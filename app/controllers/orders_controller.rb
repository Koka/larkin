require 'csv'

class OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    query = Order.order(:delivery_date, "case delivery_shift when 'M' then 0 when 'N' then 1 when 'E' then 2 end", :client_name)
    tomorrow = Date.today.strftime("%m/%d/%Y")
    render json: query.where(delivery_date: tomorrow) unless (params[:outdated] == 'true')
    render json: query.where("delivery_date is null OR delivery_date = ? OR NOT delivery_date SIMILAR TO '(0[1-9]|1[0-2])/(0[1-9]|1[0-9]|2[0-9]|3[01])/(19|20)[0-9]{2}' OR to_date(delivery_date, 'MM/DD/YYYY') < to_date(?, 'MM/DD/YYYY')", tomorrow, tomorrow) if (params[:outdated] == 'true')
  end

  def show
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
        order.origin_raw_line_1 = row[col += 1]
        order.origin_city = row[col += 1]
        order.origin_state = row[col += 1]
        order.origin_zip = row[col += 1]
        order.origin_country = row[col += 1]
        order.client_name = row[col += 1]
        order.destination_raw_line_1 = row[col += 1]
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
