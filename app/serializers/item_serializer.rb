class ItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :quantity, :unitary_cost, :discount, :tax_ids
  belongs_to :common
  has_many :taxes, links: {self: true, related: true}

  def tax_ids
     object.taxes.map {|t| t.id}
  end

end
