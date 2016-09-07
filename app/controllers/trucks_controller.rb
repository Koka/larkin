class TrucksController < ApplicationController
  before_action :authenticate_user

  def index
    render json: Truck.order(:id).all
  end

  def show
    render json: Truck.find_by(id: params[:id])
  end
end
