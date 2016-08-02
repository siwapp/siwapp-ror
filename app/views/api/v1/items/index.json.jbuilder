json.array! @items do |item|
  json.extract! item, :id, :description, :unitary_cost, :quantity, :discount
  json.taxes api_v1_item_taxes_url item
  json.url api_v1_item_url item
end
