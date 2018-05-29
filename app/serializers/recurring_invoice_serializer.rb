class RecurringInvoiceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :series_id, :currency,
    :customer_id, :identification, :name,
    :email, :contact_person, :invoicing_address,
    :shipping_address, :terms, :notes,
    :enabled, :days_to_due, :starting_date,
    :finishing_date, :period, :period_type,
    :max_occurrences, :sent_by_email,
    :net_amount, :gross_amount, :taxes,
    :tag_list, :meta

  meta do |serializer|
    if object.meta_attributes
      ActiveSupport::JSON.decode(object.meta_attributes)
    end
  end

  belongs_to :customer, url: true
  has_many :items

  link(:self) { api_v1_recurring_invoice_path(object.id) }
  link(:customer){ api_v1_customer_path(object.customer_id) }
  link(:items){ api_v1_recurring_invoice_items_path(recurring_invoice_id: object.id) }

  def initialize(object, options={})
    super
    object.set_amounts
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
