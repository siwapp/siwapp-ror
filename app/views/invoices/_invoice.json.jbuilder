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
  json.customer invoice.customer, partial: 'customers/customer', as: :customer, locals: {expand: false}
  json.items  invoice.items, partial: 'items/item', as: :item, locals: {expand: false}
  json.payments  invoice.payments, partial: 'payments/payment', as: :payment, locals: {expand: false}
  unless invoice.get_template
   json.rendered_templates @templates, partial: 'rendered_template', as: :template, locals: {invoice: invoice}
  end
else
  json.customer invoice.customer, :id, :name, :identification, :email
end
