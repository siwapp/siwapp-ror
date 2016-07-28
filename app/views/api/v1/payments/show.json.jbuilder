json.extract! @payment,:id, :amount, :date, :notes
json.url api_v1_payment_url @payment
json.invoice do
  json.id @payment.invoice.id
  json.series_number @payment.invoice.to_s
  json.url api_v1_invoice_url @payment.invoice
end