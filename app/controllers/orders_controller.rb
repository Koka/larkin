class OrdersController < ApplicationController
  before_action :authenticate_user, :dispatcher_only

  def index
    query = Order.reverse_chronologically

    query = query.not_cancelled if (params[:cancelled] == 'false')
    query = query.cancelled if (params[:cancelled] == 'true')

    query = query.not_completed if (params[:completed] == 'false')
    query = query.completed if (params[:completed] == 'true')

    query = query.pending if (params[:pending] == 'true')
    query = query.not_pending if (params[:pending] == 'false')

    query = query.not_outdated if (params[:outdated] == 'false')
    query = query.outdated if (params[:outdated] == 'true')

    render json: query
  end

  def show
    render json: Order.find_by(id: params[:id])
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
