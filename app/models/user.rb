class User < ApplicationRecord

  has_secure_password

  validates :name, presence: true
  validates :login, presence: true, uniqueness: true

  def self.from_token_request request
    login = request.params["auth"] && request.params["auth"]["login"]
    self.find_by login: login
  end

  def role
    Truck.find_by(driver_id: self.id) ? :driver : :dispatcher
  end
end
