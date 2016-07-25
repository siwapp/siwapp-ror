json.extract! @item, :id, :description, :unitary_cost, :quantity, :discount
json.url item_url @item, format: :json
json.invoice do
  json.id @item.common.id
  json.series_number @item.common.to_s
  json.url invoice_url @item.common, format: :json
end

json.taxes @item.taxes do |tax|
  json.extract! tax, :id, :name
  json.url tax_url tax, format: :json
end
