class ItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :quantity, :unitary_cost, :discount, :tax_ids
  belongs_to :common
  has_many :taxes, links: {self: true, related: true}
  link(:self) { api_v1_item_path(object.id) }
  link(:taxes){ api_v1_item_taxes_path(item_id: object.id) }

  def tax_ids
     object.taxes.map {|t| t.id}
  end

end
