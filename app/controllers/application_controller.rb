class ApplicationController < ActionController::Base
  include Knock::Authenticable
  protect_from_forgery with: :exception

  protected
    def bind_value(name, type, value)
      ActiveRecord::Attribute.from_user(name, value, ActiveRecord::Type.registry.lookup(type))
    end
end
