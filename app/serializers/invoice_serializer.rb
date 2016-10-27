class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :number, :series_id, :issue_date, :due_date,  :days_to_due,
      :number,
      :customer_id,
      :identification,
      :name,
      :email,
      :contact_person,
      :invoicing_address,
      :shipping_address,
      :terms,
      :notes,
      :draft,
      :tag_list,
      :meta_attributes
  has_many :items
  has_many :payments
end
