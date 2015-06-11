class RecurringInvoicesController < CommonsController

  def generate
    # Generates pending invoices according to date
    pending = []
    actives = RecurringInvoice.with_status(1)
    pendings = get_pendings(actives)
    while pendings do
      # Generate invoices
      processed = []
      pendings = get_pendings(processed)
    end
    redirect_to(:action => 'index')
  end

  def delayed
    # Gets recurring invoices that should be executed
    c = RecurringInvoice.with_status(1)
  end

  def get_pendings(instances)
    # Returns only those recurring_invoices that are pending to generate invoices
    pendings = []
    instances.each do |actual|
      # pick just those pending
      if actual.last_execution_date < Date.today - actual.period.send(actual.period_type)
        pendings.append(actual)
      end
    end
    pendings
  end
    

  protected

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

      :customer_identification,
      :customer_name,
      :customer_email,

      :status,
      :days_to_due,
      :invoicing_address,
      :draft,
      :starting_date,
      :finishing_date,
      :period,
      :period_type,
      :max_occurrences,
      :last_execution_date,

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
