json.array!(@series) do |serie|
  json.extract! serie, :id, :name, :value, :enabled, :default
  json.url series_url(serie, format: :json)
end
