class TaxSerializer < ActiveModel::Serializer
  attributes :id, :name, :value, :active, :default
end
