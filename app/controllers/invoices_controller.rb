class InvoicesController < CommonsController

  def show
    # Redirect to edit if invoice not closed
    if @invoice.status != Invoice::PAID
      redirect_to action: 'edit'
    end
  end

  protected

  def set_listing(instances)
    @invoices = instances
  end

  def set_instance(instance)
    @invoice = instance
  end

  def get_instance
    @invoice
  end

  def invoice_params
    [
      :series_id,
      :issue_date,
      :due_date,

      :customer_identification,
      :customer_name,
      :customer_email,

      :invoicing_address,
      :draft,

      :tag_list,

      items_attributes: [
        :id,
        :description,
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []},
        :_destroy
      ],

      payments_attributes: [
        :id,
        :date,
        :amount,
        :notes,
        :_destroy
      ]
    ]
  end
end
