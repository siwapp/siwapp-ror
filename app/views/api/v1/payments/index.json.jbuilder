json.array! @payments do |payment|
  json.extract! payment, :id, :amount, :date, :notes
  json.url api_v1_payment_url payment
end