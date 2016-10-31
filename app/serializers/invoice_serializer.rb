class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :number, :series_id, :issue_date, :due_date,  :days_to_due, :number,
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
  belongs_to :customer, url: true
  has_many :items
  has_many :payments, foreign_key: :common_id, class_name: 'Payment'

  def items
    customized_items = []
    puts object
    object.items.each do |item|
      # Assign object attributes (returns a hash)
      # ===========================================================
      custom_item = item.attributes
      # ===========================================================
      customized_items.push(custom_item)
    end
    return customized_items
  end
end
