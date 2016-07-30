json.extract! @customer, :id, :name, :name_slug, :identification, :email, :contact_person, :invoicing_address
json.url api_v1_customer_url @customer
