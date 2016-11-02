class InvoiceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  #include ActiveModel::Serialization

  attributes :id, :number, :series_id, :issue_date, 
    :due_date,  :days_to_due, :number,
    :customer_id, :identification, :name, 
    :email, :contact_person, :invoicing_address,
    :shipping_address, :terms, :notes, :draft, 
    :tag_list, :meta_attributes, :download_link
  belongs_to :customer, url: true
  has_many :items
  has_many :payments, foreign_key: :common_id

  def download_link
    if object.print_template
      template = object.print_template
    else
      template = Template.where(print_default: true)[0]
    end
    return api_v1_rendered_template_path(template, 
      object, format: :pdf)
  end

  def items
    customized_items = []
    object.items.each do |item|
      # Assign object attributes (returns a hash)
      # ===========================================================
      # ===========================================================
      custom_item = {"attributes": item.attributes}
      customized_items.push(custom_item)
    end
    return customized_items
  end
end
