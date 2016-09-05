class TruckSerializer < ActiveModel::Serializer
  attributes(*Truck.attribute_names.map(&:to_sym))
end
