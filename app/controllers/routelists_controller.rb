class RoutelistsController < ApplicationController
  def index
    list = ActiveRecord::Base.connection_pool.with_connection do |con|
      con.exec_query(
        'select load_date || \':\' || load_shift || \':\' || load_truck_id as id,'\
        'load_date as delivery_date,'\
        'load_shift as delivery_shift,'\
        'count(distinct id) as stop_count,'\
        'load_truck_id as truck_id '\
        'from orders '\
        'where load_truck_id is not null '\
        'group by load_date, load_shift, load_truck_id',
        'Load route lists'
      )
    end
    render json: {routelists: list}
  end

  def show
    id = parse_id

    list = ActiveRecord::Base.connection_pool.with_connection do |con|
      con.exec_query(
        'select load_date || \':\' || load_shift || \':\' || load_truck_id as id,'\
        'load_date as delivery_date,'\
        'load_shift as delivery_shift,'\
        'count(distinct id) as stop_count,'\
        'load_truck_id as truck_id '\
        'from orders '\
        'where load_truck_id = $1 AND load_shift = $2 AND load_date = $3 '\
        'group by load_date, load_shift, load_truck_id',
        'Load route list',
        [
          bind_value('truck', :integer, id[:truck]),
          bind_value('shift', :string, id[:shift]),
          bind_value('date', :date, id[:date])
        ]
      )
    end

    @routelist = list[0]

    puts @routelist

    respond_to do |format|
      format.json {
        @routelist[:links] = {
          stops: 'stops'
        }
        render :json => {routelist: @routelist}
      }
      format.pdf {
        @routelist[:stops] = get_stops(id)
        @routelist[:truck] = Truck.find(id[:truck])
        begin
          render :pdf => @routelist
        rescue Exception => e
          logger.error "Failed to create PDF..."

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
    id = parse_id

    list = get_stops(id)

    render json: { orders: list}
  end

  private
    def get_stops(id)
      Order.where(load_truck_id: id[:truck], load_shift: id[:shift], load_date: id[:date])
    end

    def parse_id
      id = params[:id].split(':')
      {
        truck: id[2],
        shift: id[1],
        date: id[0]
      }
    end

    def bind_value(name, type, value)
      ActiveRecord::Attribute.from_user(name, value, ActiveRecord::Type.registry.lookup(type))
    end
end
