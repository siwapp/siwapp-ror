json.extract! invoice,
  :id, :series_id, :draft, :sent_by_email,
  :name, :identification, :email, :invoicing_address, :shipping_address, :contact_person,
  :terms, :notes,
  :base_amount, :discount_amount, :net_amount, :gross_amount, :paid_amount, :tax_amount,
  :issue_date, :due_date, :days_to_due,
  :created_at, :updated_at

json.url api_v1_invoice_url invoice
json.series_number invoice.to_s
json.status invoice.get_status
if invoice.get_template
   json.download_link rendered_template_url id: invoice.get_template.id, invoice_id: invoice.id, format: :pdf
end

if expand

  json.customer do
    json.extract! invoice.customer, :id, :identification
    json.url api_v1_customer_url invoice.customer
  end
  json.items invoice.items do |item|
    json.extract! item, :id, :description, :unitary_cost, :quantity, :discount
    json.url api_v1_item_url item
    json.taxes item.taxes do |tax|
      json.extract! tax, :id, :name, :value
      json.url api_v1_tax_url tax
    end
  end

  json.payments invoice.payments do |payment|
    json.extract! payment, :id, :notes, :amount, :date
    json.url api_v1_payment_url payment
  end

  unless invoice.get_template
    json.rendered_templates @templates, partial: 'rendered_template', as: :template, locals: {invoice: invoice}
  end

else

  json.customer api_v1_customer_url invoice.customer
  json.items api_v1_invoice_items_url invoice
  json.payments api_v1_invoice_payments_url invoice

end
