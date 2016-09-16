class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected
    def bind_value(name, type, value)
      ActiveRecord::Attribute.from_user(name, value, ActiveRecord::Type.registry.lookup(type))
    end
end
