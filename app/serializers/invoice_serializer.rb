class InvoiceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  #include ActiveModel::Serialization

  attributes :id, :number, :series_id, :currency,
    :issue_date, :due_date,  :days_to_due, :number,
    :customer_id, :identification, :name,
    :email, :contact_person, :invoicing_address,
    :shipping_address, :terms, :notes, :draft,
    :tag_list, :download_link, :meta,
    :net_amount, :gross_amount, :taxes, :status,
    :sent_by_email

  meta do |serializer|
    if object.meta_attributes
      ActiveSupport::JSON.decode(object.meta_attributes)
    end
  end

  belongs_to :customer, url: true
  has_many :items
  has_many :payments, foreign_key: :common_id
  link(:self) { api_v1_invoice_path(object.id) }
  link(:customer){ api_v1_customer_path(object.customer_id) }
  link(:items){ api_v1_invoice_items_path(invoice_id: object.id) }
  link(:payments){ api_v1_invoice_payments_path(invoice_id: object.id) }

  def initialize(object, options={})
    super
    object.set_amounts
  end

  def status
    object.get_status
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

  def items
    customized_items = []
    object.items.each do |item|
      custom_item = {"attributes": item.attributes}
      customized_items.push(custom_item)
    end
    return customized_items
  end

end
