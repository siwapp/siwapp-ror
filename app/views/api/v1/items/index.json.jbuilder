#json.array! @items, partial: 'item', as: :item, locals: {expand: false}

json.array! @items do |item|
  json.extract! item, :id, :description, :unitary_cost, :quantity, :discount
  json.url api_v1_item_url item
end

