class CustomerSerializer < ActiveModel::Serializer
  attributes :name, :identification, :email, :contact_person, :invoicing_address, :shipping_address
end
