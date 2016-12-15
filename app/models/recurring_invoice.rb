class RecurringInvoice < Common

  # make this object a publisher
  include Wisper::Publisher

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

  CSV_FIELDS = [
    "id", "series", "customer_id", "name", "identification",
    "email", "invoicing_address", "shipping_address",
    "contact_person", "terms",
    "notes", "net_amount", "tax_amount",
    "gross_amount", "draft",
    "sent_by_email", "days_to_due", "enabled", "max_occurrences",
    "must_occurrences", "period", "period_type",
    "starting_date", "finishing_date", "created_at", "updated_at",
    "print_template_id"
  ]

  def to_s
    "#{name}"
  end

  def next_invoice_date
    self.invoices.length > 0 ? self.invoices.last.issue_date + period.send(period_type) : starting_date
  end

  def get_pending_invoices
    # Returns a list of invoices pending for this RecurringInvoice
    # how many invoices have been generated so far
    occurrences = Invoice.belonging_to(id).count
    next_date = next_invoice_date()
    pending_invoices = []

    while next_date <= [Date.current, finishing_date.blank? ? Date.current + 1 : finishing_date].min and
        (max_occurrences.nil? or occurrences < max_occurrences) do
      inv = self.becomes(Invoice).deep_clone include: { items: :taxes}, except: [:period, :period_type, :starting_date, :finishing_date, :max_occurrences]

      inv.recurring_invoice_id = self.id
      inv.issue_date = next_date
      inv.due_date = Date.current + days_to_due.days if days_to_due
      inv.sent_by_email = false
      inv.meta_attributes = meta_attributes

      inv.items.each do |item|
        item.description.sub! "$(issue_date)", inv.issue_date.strftime('%Y-%m-%d')
        item.description.sub! "$(issue_date - period)", (inv.issue_date - period.send(period_type)).strftime('%Y-%m-%d')
        item.description.sub! "$(issue_date + period)", (inv.issue_date + period.send(period_type)).strftime('%Y-%m-%d')
       end

      broadcast(:invoice_generation, inv)
      next_date += period.send period_type
      occurrences += 1
      pending_invoices.append inv
    end

    pending_invoices
  end

  def self.generate_pending_invoices
    # Generates and saves all the pending invoices
    invoices = []  # list of invoices to generate
    where(:enabled => true).where("starting_date <= ?", Date.current).each \
        { |r_inv| invoices += r_inv.get_pending_invoices }
    invoices.sort_by!(&:issue_date)

    invoices.each do |inv|
      if inv.save
        begin  # silently ignore errors sending emails here
          inv.send_email if self.find(inv.recurring_invoice_id).sent_by_email
        rescue Exception => e
        end
      end
    end
    invoices
  end

  private

  def valid_date_range
    return if starting_date.blank? || finishing_date.blank?

    if starting_date > finishing_date
      errors.add(:finishing_time, "The end date must be greater than the start date.")
    end
  end

end
