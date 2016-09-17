class OrdersController < ApplicationController
  before_action :authenticate_user, :dispatcher_only

  def index
    state = params.slice(:cancelled, :completed, :pending, :outdated)
    query = Order.reverse_chronologically.for_state state
    render json: query
  end

  def show
    render json: Order.find(params[:id])
  end

  def schedule
    ScheduleOrders.build.call params[:truck], params[:shift], Date.parse(params[:date]), params[:orders]
  end

  def move_up
    Order.find(params[:id]).move_up!
  end

  def move_down
    Order.find(params[:id]).move_down!
  end

  def split
    Order.find(params[:id]).split!
  end

  def update
    order = Order.find(params[:id])
    order.update_attributes!(params.require(:order).permit!)
    render json: order
  end

  def upload
    UploadOrders.build.call params.require(:file)
  end

end
