class TrucksController < ApplicationController
  before_action :authenticate_user

  def index
    render json: Truck.order(:id).all
  end

  def show
    render json: Truck.find_by(id: params[:id])
  end

  def shifts
    result = ActiveRecord::Base.connection_pool.with_connection do |con|
      con.exec_query("
          select shift_count FROM (
            select
            id,
            case row_number() over () % 2 = EXTRACT(DOY FROM $2::date)::bigint % 2
            when true then ($3 / 2)
            else $3 - ($3 / 2)
            end as shift_count
            from trucks
            order by id
          ) S where S.id = $1
        ",
        'Get truck shift count for date',
        [
          bind_value('truck', :integer, params[:id]),
          bind_value('date', :date, params[:date]),
          bind_value('total_shifts', :integer, 3)
        ]
      )
    end

    shift_count = result[0] ? result[0]["shift_count"] : 0

    render json: shift_available?(shift_count, params[:shift])
  end

  private
    def shift_available?(shift_count, shift)
      all_shifts = ['M', 'N', 'E']
      trips_left = shift_count
      need_rest = false
      start_shift = all_shifts.length - 1 - trips_left
      for i in start_shift..(all_shifts.length - 1) do
        if need_rest then
          need_rest = false
          next
        end

        if trips_left > 0 then
          trips_left -= 1
          need_rest = true
          if all_shifts[i] == shift then
            return true
          end
        end
      end
      return false
    end
end
