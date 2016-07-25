json.extract! @customer, :id, :name, :identification, :email, :contact_person, :invoicing_address, :shipping_address
json.url customer_url @customer, format: :json
json.invoices @customer.invoices do |invoice|
  json.extract! invoice, :id
  json.series_number invoice.to_s
  json.url invoice_url invoice, format: :json
end