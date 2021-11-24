class ServiceSerializer < ActiveModel::Serializer
    attributes :id, :name, :value, :active
  end
  