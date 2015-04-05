class RecurringInvoicesController < CommonsController

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

  def type_params
    params
      .require(:recurring_invoice)
      .permit(
        :serie_id,

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
        :max_occurrences
      )
  end

end
