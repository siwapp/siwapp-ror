class RecurringInvoicesController < CommonsController

  def generate
    # Generates pending invoices according to date
    pending = []
    actives = RecurringInvoice.with_status(1)
    pendings = get_pendings(actives)
    while not pendings.empty? do
      # Generate invoices
      processed = []
      pendings.each do |p|
        if p.max_occurrences
          # Stop if Max number of invoices has been reached
          break if Invoice.belonging_to(p.id).count >= p.max_occurrences
        end
        inv = p.becomes(Invoice).deep_clone include: [:payments, :items]
        inv.recurring_invoice_id = p.id
        inv.status = 'Open'
        inv.issue_date = Date.today
        inv.due_date = Date.today + p.days_to_due.days if p.days_to_due
        # saving new generated invoice
        inv.save()
        # updating last_execution_date on p
        p.last_execution_date += p.period.send(p.period_type)
        p.save()
        # adding processed recurring_invoice to list to check if up-to-date
        processed.append(p)
      end
      pendings = get_pendings(processed)
    end
    redirect_to invoices_url
  end

  def get_pendings(instances)
    # Returns only those recurring_invoices that are pending to generate invoices
    pendings = []
    instances.each do |actual|
      if not actual.last_execution_date
        # if not date, prepare  next iteration to be on starting_date
        actual.last_execution_date = actual.starting_date - actual.period.send(actual.period_type)
      end
      # pick just those pending
      next_date = actual.last_execution_date + actual.period.send(actual.period_type)
      valid_range = (actual.starting_date...actual.finishing_date)
      if next_date < Date.today and next_date.in? valid_range
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
