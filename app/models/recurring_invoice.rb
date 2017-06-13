class RecurringInvoice < Common
  # Relations
  has_many :invoices

  # Validation
  validates :starting_date, presence: true
  validates :period_type, presence: true
  validates :period, presence: true,
            numericality: {only_integer: true, greater_than: 0}
  validate :valid_date_range

  PERIOD_TYPES = [
    ["Daily", "day"],
    ["Monthly", "month"],
    ["Yearly", "year"]
  ].freeze

  CSV_FIELDS = Common::CSV_FIELDS + ["series", "days_to_due", "enabled",
    "max_occurrences", "must_occurrences", "period", "period_type",
    "starting_date", "finishing_date"]

  # acts_as_paranoid behavior
  def paranoia_destroy_attributes
    {
      deleted_at: current_time_from_proper_timezone,
      enabled: false
    }
  end

  def to_s
    "#{name}"
  end

  # Returns the issue date of the next invoice that must be generated
  def next_invoice_date
    self.invoices.length > 0 ? self.invoices.order(:id).last.issue_date + period.send(period_type) : starting_date
  end

  # Returns the list of issue dates for all pending invoices
  def next_occurrences
    result = []

    occurrences = Invoice.belonging_to(id).count
    next_date = next_invoice_date
    max_date = [Date.current, finishing_date.blank? ? Date.current + 1 : finishing_date].min

    while next_date <= max_date and (max_occurrences.nil? or occurrences < max_occurrences) do
      result.append(next_date)
      occurrences += 1
      next_date += period.send period_type
    end

    result
  end

  # Returns a list of (not-yet-saved) pending invoices for this instance.
  def build_pending_invoices
    next_occurrences.map do |issue_date|
      invoice = self.becomes(Invoice).dup
      
      invoice.period = nil
      invoice.period_type = nil
      invoice.starting_date = nil
      invoice.finishing_date = nil
      invoice.max_occurrences = nil

      self.items.each do |item|
        nitem = Item.new(item.attributes)
        nitem.id = nil
        item.taxes.each do |tax|
          nitem.taxes << tax
        end
        invoice.items << nitem
      end

      invoice.recurring_invoice = self
      invoice.issue_date = issue_date
      invoice.due_date = invoice.issue_date + days_to_due.days if days_to_due
      invoice.sent_by_email = false
      invoice.meta_attributes = meta_attributes

      invoice.items.each do |item|
        item.description.sub! "$(issue_date)", invoice.issue_date.strftime('%Y-%m-%d')
        item.description.sub! "$(issue_date - period)", (invoice.issue_date - period.send(period_type)).strftime('%Y-%m-%d')
        item.description.sub! "$(issue_date + period)", (invoice.issue_date + period.send(period_type)).strftime('%Y-%m-%d')
      end

      invoice
    end
  end

  # Builds and save ordered (by issue date) all pending invoices for all the
  # enabled recurring invoices.
  def self.build_pending_invoices!
    invoices = []

    where(:enabled => true).where("starting_date <= ?", Date.current).each do |r_inv|
      invoices += r_inv.build_pending_invoices
    end

    invoices.sort_by!(&:issue_date)

    invoices.each do |invoice|
      if invoice.save
        invoice.trigger_event(:invoice_generation)
        begin
          invoice.send_email if invoice.recurring_invoice.sent_by_email
        rescue Exception
          # silently ignore
        end
      end
    end

    invoices
  end

  def self.any_invoices_to_be_built?
    where(:enabled => true).where("starting_date <= ?", Date.current).each do |r_inv|
      if r_inv.next_occurrences.length > 0
        return true
      end
    end
    return false
  end

  private

  def valid_date_range
    return if starting_date.blank? || finishing_date.blank?

    if starting_date > finishing_date
      errors.add(:finishing_date, "The end date must be greater than the start date.")
    end
  end
end
