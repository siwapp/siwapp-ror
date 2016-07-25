json.array! @customers do |customer|
  json.extract! customer, :id, :name, :identification, :email, :contact_person
  json.url customer_url customer, format: :json
end
