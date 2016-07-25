json.extract! @payment,:id, :amount, :date, :notes
json.url payment_url @payment, format: :json
json.invoice do
  json.id @payment.invoice.id
  json.series_number @payment.invoice.to_s
  json.url invoice_url @payment.invoice, format: :json
end
