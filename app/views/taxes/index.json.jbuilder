json.array!(@taxes) do |tax|
  json.extract! tax, :id, :name, :value, :default, :active
  json.url tax_url tax, format: :json
end
