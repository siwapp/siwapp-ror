json.array! @payments do |payment|
  json.extract! payment, :id, :amount, :date, :notes
  json.url payment_url payment, format: :json
end
