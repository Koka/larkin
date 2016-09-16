class ApplicationController < ActionController::Base
  include Knock::Authenticable
  protect_from_forgery with: :exception

  protected
    def bind_value(name, type, value)
      #TODO: killlme pls
      ActiveRecord::Attribute.from_user(name, value, ActiveRecord::Type.registry.lookup(type))
    end

    def get_my_truck_id()
      truck = Truck.find_by(driver_id: current_user.id)
      truck ? truck.id : nil
    end

    def dispatcher_only
      raise 'Only dispatcher is allowed to do this action' unless current_user.role == :dispatcher
    end
end
