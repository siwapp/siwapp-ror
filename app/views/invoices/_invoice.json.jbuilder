json.extract! invoice,
  :id, :series_id, :draft, :sent_by_email,
  :name, :identification, :email, :invoicing_address, :shipping_address, :contact_person,
  :terms, :notes,
  :base_amount, :discount_amount, :net_amount, :gross_amount, :paid_amount, :tax_amount,
  :issue_date, :due_date, :days_to_due,
  :created_at, :updated_at

json.url invoice_url(invoice, format: :json)
json.series_number invoice.to_s
json.status invoice.get_status
if invoice.get_template
   json.download_link rendered_template_url id: invoice.get_template.id, invoice_id: invoice.id, format: 'pdf'
end

if expand

  json.customer do
    json.extract! invoice.customer, :id, :identification
    json.url customer_url invoice.customer, format: :json
  end
  json.items invoice.items do |item|
    json.extract! item, :id, :description, :unitary_cost, :quantity, :discount
    json.url item_url item, format: :json
  end

  json.payments invoice.payments do |payment|
    json.extract! payment, :id, :notes, :amount, :date
    json.url payment_url payment, format: :json
  end

  unless invoice.get_template
    json.rendered_templates @templates, partial: 'rendered_template', as: :template, locals: {invoice: invoice}
  end

else

  json.customer customer_url invoice.customer, format: :json
  json.items invoice_items_url invoice, format: :json
  json.payments invoice_payments_url invoice, format: :json

end
