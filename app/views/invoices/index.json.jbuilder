json.array!(@invoices) do |invoice|
  json.extract! invoice, :id
  json.url invoice_url(invoice, format: :json)
end
