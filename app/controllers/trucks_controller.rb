class TrucksController < ApplicationController
  before_action :authenticate_user, :dispatcher_or_this_truck_driver
  skip_before_action :dispatcher_or_this_truck_driver, only: [:index]

  def index
    render json: Truck.visible_to(current_user)
  end

  def show
    render json: Truck.find(params[:id])
  end

  def shift_available
    render json: Truck.find(params[:id]).shift_available?(params[:date], params[:shift])
  end

  private
    def dispatcher_or_this_truck_driver
      raise 'Invalid truck id' unless current_user.truck.nil? || params[:id].to_i == current_user.truck.id
    end
end
