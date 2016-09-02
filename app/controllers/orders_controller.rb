class OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    render json: Order.all
  end

  def show
    render json: Order.find_by(id: params[:id])
  end

  def upload
    
  end

end
