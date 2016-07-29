class Api::V1::InvoicesController < Api::V1::CommonsController

  include CommonsHelper

  set_pagination_headers :invoices, only: [:index]


  protected

  def set_instance instance
    @invoice = instance
  end

  def get_instance
    @invoice
  end

  def set_listing instances
    @invoices = instances
  end

  def invoice_params
    [
      :series_id,
      :issue_date,
      :due_date,
      :days_to_due,

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

      { items_attributes: [
        :id,
        :description,
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []}
      ]},

      {payments_attributes: [
        :id,
        :date,
        :amount,
        :notes
      ]}
    ]
  end


end
