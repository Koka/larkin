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
    id = params[:id].split(':')

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
          bind_value('truck', :integer, id[2]),
          bind_value('shift', :string, id[1]),
          bind_value('date', :date, id[0])
        ]
      )
    end
    render json: {routelist: list[0]}
  end

  private
    def bind_value(name, type, value)
      ActiveRecord::Attribute.from_user(name, value, ActiveRecord::Type.registry.lookup(type))
    end
end
