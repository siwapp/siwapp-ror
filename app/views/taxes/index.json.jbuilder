json.array!(@taxes) do |tax|
  json.extract! tax, :id
  json.url tax_url(tax, format: :json)
end
