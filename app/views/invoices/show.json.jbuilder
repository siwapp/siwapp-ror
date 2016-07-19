json.extract! @invoice,
  :id, :series_id, :draft, :sent_by_email,
  :name, :identification, :email, :invoicing_address, :shipping_address, :contact_person,
  :terms, :notes,
  :base_amount, :discount_amount, :net_amount, :gross_amount, :paid_amount, :tax_amount,
  :issue_date, :due_date, :days_to_due,
  :created_at, :updated_at

json.series_number @invoice.to_s
json.status @invoice.get_status

json.customer @invoice.customer, :id, :name, :identification, :email

json.items  @invoice.items, :id, :description, :unitary_cost, :quantity, :discount
json.payments  @invoice.payments, :id, :date, :amount, :notes
