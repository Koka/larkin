class ApplicationController < ActionController::Base
  include Knock::Authenticable
  protect_from_forgery with: :exception

  protected
    def dispatcher_only
      raise 'Only dispatcher is allowed to do this action' unless current_user.role == :dispatcher
    end
end
