json.extract! item, :id, :description, :unitary_cost, :quantity, :discount
json.url item_url(item, id: item.id, format: :json)
if expand
  json.invoice do
    json.id  item.common.id
    json.series_number item.common.to_s
    json.name item.common.name
    json.url invoice_url(item.common, format: :json)
  end
end