class RoutelistsController < ApplicationController
  before_action :authenticate_user, :dispatcher_or_this_truck_driver
  skip_before_action :dispatcher_or_this_truck_driver, only: [:index]

  def index
    query = Order.routelists.scheduled_for_user current_user
    render json: {routelists: query}
  end

  def show
    @routelist = Order.routelists.scheduled_with_order(Order.find(params[:id])).first

    respond_to do |format|
      format.json {
        render :json => {
          routelist: @routelist.attributes.merge({
            links: {
              stops: 'stops'
            }
          })
        }
      }

      format.pdf {
        begin
          render :pdf => @routelist
        rescue Exception => e
          logger.error "Failed to create PDF!"

          log_file = e.message.scan(/\/.*\.log/).first
          if log_file && File.exists?(log_file)
              puts "--- Latex Log ---\n"
              puts File.read(log_file)
              puts "---   Latex Log End    ---\n\n"
          end
        end
      }
    end

  end

  def stops
    list = Order.find(params[:id]).routelist_stops
    render json: { orders: list}
  end

  private
    def dispatcher_or_this_truck_driver
      truck = Order.find(params[:id]).load_truck
      raise 'Invalid truck id' unless current_user.truck.nil? || truck.id == current_user.truck.id
    end
end
