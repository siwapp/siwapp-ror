json.array!(@taxes) do |tax|
  json.extract! tax, :id, :name, :value, :default, :active
  json.url api_v1_tax_url tax
end
