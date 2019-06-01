class Invoice < Common
  # Relations
  belongs_to :recurring_invoice, optional: true
  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments, :reject_if => :all_blank, :allow_destroy => true

  # Validation
  validates :issue_date, presence: true
  validates :number, numericality: { only_integer: true,
    allow_nil: true }
  validates_uniqueness_of :number,  scope: :series, conditions: -> { where.not(draft: true) }

  # Events
  around_save :assign_invoice_number
  after_save :purge_payments
  after_save :update_paid

  after_initialize :init

  CSV_FIELDS = Common::CSV_FIELDS + ["to_s", "paid_amount", "paid", "number",
    "recurring_invoice_id", "issue_date", "due_date", "failed"]

  scope :with_status, ->(status) {
    return nil if status.empty?
    status = status.to_sym
    case status
    when :draft
      where(draft: true)
    when :failed
      where(draft: false, failed: true)
    when :paid
      where(draft: false, failed: false, paid: true)
    when :pending
      where(draft: false, failed: false, paid: false).where("due_date > ?", Date.current)
    when :past_due
      where(draft: false, failed: false, paid: false).where("due_date <= ?", Date.current)
    end
  }

  # Invoices belonging to certain recurring_invoice
  scope :belonging_to, -> (r_id) {where recurring_invoice_id: r_id}

  def init
    begin
      # Set defaults
      unless self.id
        self.issue_date ||= Date.current()
        self.due_date ||= self.issue_date + Integer(Settings.days_to_due).days
      end
    # Using scope.select also triggers this init method
    # so we have to deal with this exception
    rescue ActiveModel::MissingAttributeError
    end
    super
  end

  # acts_as_paranoid behavior
  def paranoia_restore_attributes
    {
      deleted_at: nil,
      draft: true
    }
  end

  def paranoia_destroy_attributes
    {
      deleted_number: self.number,
      deleted_at: current_time_from_proper_timezone,
      number: nil
    }
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, *(serializable_attribute_names))
      json.series_number to_s
      json.status get_status
      if customer
        json.customer customer.to_jbuilder
      end
      json.items items.collect { |item| item.to_jbuilder.attributes! }
      json.payments payments.collect {|payment| payment.to_jbuilder.attributes!}
    end
  end

  def self.status_collection
    [["Draft", :draft], ["Paid", :paid], ["Pending", :pending],
      ["Past Due", :past_due], ["Failed", :failed]]
  end

  # Public: Get a string representation of this object
  #
  # Returns a string.
  def to_s
    label = draft ? '[draft]' : number
    "#{series.value}#{label}"
  end

  # Public: Returns the status of the invoice based on certain conditions.
  #
  # Returns a symbol.
  def get_status
    if draft
      :draft
    elsif failed
      :failed
    elsif paid
      :paid
    elsif due_date
      if due_date > Date.current
        :pending
      else
        :past_due
      end
    else
      # An invoice without a due date can't be past_due
      :pending
    end
  end

  # Public: Returns the amount that has not been already paid.
  #
  # Returns a double.
  def unpaid_amount
    gross_amount - paid_amount
  end

  # Public: Adds a payment for the remaining unpaid amount and updates the
  # invoice status.
  #
  def set_paid
    if not draft and (unpaid_amount > 0 and not paid)
      payments << Payment.new(date: Date.current, amount: unpaid_amount)
      check_paid
      true
    else
      false
    end
  end

  # Public: Adds a payment for the remaining unpaid amount and updates the
  # invoice status. This method saves the invoice.
  #
  def set_paid!
    if set_paid
      self.save
      true
    else
      false
    end
  end

  # Public: Check the payments and update the paid and
  # paid_amount fields
  #
  def check_paid
    self.paid_amount = 0
    self.paid = false
    payments.each do |payment|
      self.paid_amount += payment.amount
    end

    if self.paid_amount - self.gross_amount >= 0
      self.paid = true
    end
  end

  # Public: After saving check the payments and update the paid and
  # paid_amount fields
  #
  def update_paid
    self.check_paid
    # Use update_columns to skip more callbacks
    self.update_columns(paid: self.paid, paid_amount: self.paid_amount)
  end

  # Public: Calculate totals for this invoice by iterating items and payments.
  #
  # Returns nothing.
  def set_amounts
    super
    self.check_paid
    paid_amount_will_change!
    nil
  end

  # Sends email to user with the invoice attached
  def send_email
    # There is a deliver_later method which we could use
    InvoiceMailer.email_invoice(self).deliver_now
    self.sent_by_email = true
    self.save
  end

  # Returns the pdf file
  def pdf(html)
    WickedPdf.new.pdf_from_string(html,
      margin: {:top => "20mm", :bottom => 0, :left => 0, :right => 0})
  end


  protected

    # Declare scopes for search
    def self.ransackable_scopes(auth_object = nil)
      super + [:with_status]
    end

    # Assigns a number to the invoice:
    # - nil, if draft
    # - already assigned number, if any and not draft
    # - next_number of the already assigned series
    # Returns nothing.
    def assign_invoice_number
  		# wrap in a transaction to prevent race conditions
      Invoice.transaction do
        if draft
          self.number = nil
        elsif self.number.nil?
          self.number = series.next_number
        end
        yield
      end
    end

    # make sure every soft-deleted payment is really deleted
    def purge_payments
      payments.only_deleted.delete_all
    end

  private

    # attributes fitted for serialization
    def serializable_attribute_names
      [:id, :name, :identification, :email, :currency, :invoicing_address, :shipping_address, :contact_person, :terms, :notes, :net_amount, :gross_amount, :paid_amount, :issue_date, :due_date, :days_to_due]
    end
end
