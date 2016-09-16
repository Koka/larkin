class Order < ApplicationRecord
  belongs_to :load_truck, class_name: "Truck", optional: true

  before_save :parse_delivery_date
  before_save :assign_load_ordinal

  scope :reverse_chronologically, -> { order(
    "coalesce(load_date, parsed_delivery_date) DESC",
    "(case coalesce(load_shift, delivery_shift) when 'M' then 0 when 'N' then 1 when 'E' then 2 else -1 end) DESC",
    :client_name
  ) }

  scope :not_cancelled, -> { where(cancelled: false).or(query.where(cancelled: nil)) }

  scope :cancelled, -> { where(cancelled: true) }

  scope :not_completed, -> { where(load_truck_id: nil) }

  scope :completed, -> { where.not(load_truck_id: nil) }

  scope :pending, -> { where("load_date >= current_date") }

  scope :not_pending, -> { where("load_date IS NULL OR load_date < current_date") }

  scope :not_outdated, -> { where("parsed_delivery_date >= current_date") }

  scope :outdated, -> { where("parsed_delivery_date IS NULL OR parsed_delivery_date < current_date") }

  scope :ordinal_next, -> (id) {
    where(["id = (
          select o1.id
          from orders o1
          inner join orders o2 on (o1.load_truck_id, o1.load_shift, o1.load_date) = (o2.load_truck_id, o2.load_shift, o2.load_date)
          where
            o1.load_ordinal > o2.load_ordinal
            AND o2.id = ?
          order by o1.load_ordinal ASC
          limit 1
    )", id])
  }

  scope :ordinal_previous, -> (id) {
    where(["id = (
          select o1.id
          from orders o1
          inner join orders o2 on (o1.load_truck_id, o1.load_shift, o1.load_date) = (o2.load_truck_id, o2.load_shift, o2.load_date)
          where
            o1.load_ordinal < o2.load_ordinal
            AND o2.id = ?
          order by o1.load_ordinal DESC
          limit 1
    )", id])
  }

  def move_up!
    prev = Order.ordinal_previous(self.id)
    swap_load_ordinals(prev.first)
  end

  def move_down!
    succ = Order.ordinal_next(self.id)
    swap_load_ordinals(succ.first)
  end

  def split!
    transaction do
      part = self.dup

      qty = self.handling_unit_quantity.to_i
      vol = self.volume.to_f
      vol_per_item = vol / qty

      self.handling_unit_quantity = qty / 2
      part.handling_unit_quantity = qty - (qty / 2)

      self.volume = vol_per_item * qty / 2
      part.volume = vol - (vol_per_item * qty / 2)

      self.save
      part.save
    end
  end

  private
    def parse_delivery_date
      if self.delivery_date && /(0?[1-9]|1[012])[\/-](0?[1-9]|[12][0-9]|3[01])[\/-][12][0-9]{3}/.match(self.delivery_date) then
        self.parsed_delivery_date = Date.strptime(self.delivery_date, '%m/%d/%Y')
      end
    end

    def assign_load_ordinal
      return if self.load_truck.nil? || self.load_shift.nil? || self.load_date.nil?

      puts "!!!!!!!!!!!!!!ASSIGN ORDINAL!!!"

      result = ActiveRecord::Base.connection_pool.with_connection do |con|
        con.exec_query("
             select max(coalesce(load_ordinal, 0)) + 1 as new_ordinal
              from orders
              where (load_truck_id, load_shift, load_date) = ($1, $2, $3)
            ",
            'Select next order load ordinal',
            [
              bind_value('truck', :integer, self.load_truck),
              bind_value('shift', :string, self.load_shift),
              bind_value('date', :date, self.load_date)
            ]
        )
      end

      self.load_ordinal = result[0] && result[0]["new_ordinal"] ? result[0]["new_ordinal"] : 0
    end

    def swap_load_ordinals(target)
      return if target.nil?

      ord1 = self.load_ordinal
      ord2 = target.load_ordinal

      return if ord1 == ord2

      transaction do
        target.update_attributes!(load_ordinal: -self.id)

        self.update_attributes!(load_ordinal: ord2)
        target.update_attributes!(load_ordinal: ord1)
      end unless target.nil?
    end
end
