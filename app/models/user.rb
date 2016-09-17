class User < ApplicationRecord

  has_secure_password

  has_one :truck, foreign_key: 'driver_id', inverse_of: :driver

  validates :name, presence: true
  validates :login, presence: true, uniqueness: true

  def self.from_token_request request
    login = request.params["auth"] && request.params["auth"]["login"]
    self.find_by login: login
  end

  def self.from_token_payload payload
    self.find payload['sub']
  end

  def role
    self.truck.nil? ? :dispatcher : :driver
  end
end
