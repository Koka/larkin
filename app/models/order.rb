class Order < ApplicationRecord
  belongs_to :load_truck, class_name: "Truck", optional: true

  before_save :parse_delivery_date

  private
    def parse_delivery_date
      if self.delivery_date && /(0?[1-9]|1[012])[\/-](0?[1-9]|[12][0-9]|3[01])[\/-][12][0-9]{3}/.match(self.delivery_date) then
        self.parsed_delivery_date = Date.strptime(self.delivery_date, '%m/%d/%Y')
      end
    end
end
