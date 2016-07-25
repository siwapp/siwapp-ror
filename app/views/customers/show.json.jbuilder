json.extract! @customer, :id, :name, :identification, :email, :contact_person, :invoicing_address, :shipping_address
json.url customer_url @customer, format: :json
json.invoices customer_invoices_url  @customer.id, format: :json
