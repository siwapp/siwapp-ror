json.extract! @item, :id, :description, :unitary_cost, :quantity, :discount
json.url api_v1_item_url @item
json.invoice do
  json.id @item.common.id
  json.series_number @item.common.to_s
  json.url api_v1_invoice_url @item.common
end

json.taxes @item.taxes do |tax|
  json.extract! tax, :id, :name
  json.url api_v1_tax_url tax
end
