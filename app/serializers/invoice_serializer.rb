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
  link(:self) { api_v1_invoice_path(object.id) }
  link(:customer){ api_v1_customer_path(object.customer_id) }
  link(:items){ api_v1_invoice_items_path(invoice_id: object.id) }
  link(:payments){ api_v1_invoice_payments_path(invoice_id: object.id) }

  def meta_attributes
    if object.meta_attributes
      return ActiveSupport::JSON.decode(object.meta_attributes)
    end
  end

  def download_link
    if object.print_template
      template = object.print_template
    else
      template = Template.where(print_default: true)[0]
    end
    return api_v1_rendered_template_path(template, object)
  end

  def payments
    customized_payments = []
    object.payments.each do |payment|
      custom_payment = {"attributes": payment.attributes}
      customized_payments.push(custom_payment)
    end
    return customized_payments
  end

end
