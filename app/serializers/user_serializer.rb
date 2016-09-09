class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :login, :role
end
