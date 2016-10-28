class ItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :quantity, :unitary_cost, :discount
  belongs_to :common
  has_many :taxes
end