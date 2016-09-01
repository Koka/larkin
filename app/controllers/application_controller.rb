class ApplicationController < ActionController::Base
  include Knock::Authenticable
  protect_from_forgery with: :exception
end
