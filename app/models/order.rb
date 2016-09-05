class Order < ApplicationRecord
  belongs_to :load_truck, class_name: "Truck", optional: true
end
