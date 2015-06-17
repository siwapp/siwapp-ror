json.array!(@templates) do |template|
  json.extract! template, :id
  json.url template_url(template, format: :json)
end
