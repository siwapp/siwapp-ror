class CommonSerializer < ActiveModel::Serializer
  attributes :id, :number, :series_id, :issue_date, :due_date,  :days_to_due,
      :invoice_number,
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

  def items
    customized_items = []
    object.items.each do |item|
      custom_item = {"attributes": item.attributes}
      customized_items.push(custom_item)
    end
    return customized_items
  end
end
