json.array! @customers do |c|
    json.label c.name
    json.value c.name
    json.id c.id
    json.identification c.identification
    json.email c.email
    json.contact_person c.contact_person
    json.invoicing_address c.invoicing_address
    json.shipping_address c.shipping_address
end