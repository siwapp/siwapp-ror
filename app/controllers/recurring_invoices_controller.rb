class RecurringInvoicesController < CommonsController

  def generate
    # Generates pending invoices up to today
    for r in RecurringInvoice.with_pending_invoices
      r.generate_pending_invoices
    end
    redirect_to invoices_url
  end

  def index
    @has_pendings = (not RecurringInvoice.with_pending_invoices.empty?)
    super
  end

  protected

  def configure_search
    super
    @search_filters = true
  end

  def set_listing(instances)
    @recurring_invoices = instances
  end

  def set_instance(instance)
    @recurring_invoice = instance
  end

  def get_instance
    @recurring_invoice
  end

  def recurring_invoice_params
    [
      :series_id,

      :customer_id,
      :identification,
      :name,
      :email,
      :contact_person,
      :invoicing_address,
      :shipping_address,

      :status,
      :days_to_due,
      :draft,
      :starting_date,
      :finishing_date,
      :period,
      :period_type,
      :max_occurrences,
      :sent_by_email,

      :tag_list,

      items_attributes: [
        :id,
        :description,
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []},
        :_destroy
      ]
    ]
  end

end
