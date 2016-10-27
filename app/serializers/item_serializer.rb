class ItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :quantity, :unitary_cost, :discount
  has_many :taxes
end
