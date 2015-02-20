json.array!(@series) do |serie|
  json.extract! serie, :id
  json.url serie_url(serie, format: :json)
end
