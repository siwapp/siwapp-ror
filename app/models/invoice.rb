class Invoice < Common
  # Relations
  belongs_to :recurring_invoice
  has_many :payments, dependent: :delete_all
  accepts_nested_attributes_for :payments, :reject_if => :all_blank, :allow_destroy => true

  # Validation
  validates :series, presence: true
  validates :issue_date, presence: true
  validates :number, numericality: { only_integer: true, allow_nil: true }

  # Events
  before_save :set_status
  around_save :ensure_invoice_number, if: :needs_invoice_number

  # Status
  PAID = 1
  PENDING = 2
  OVERDUE = 3

  STATUS = {paid: PAID, pending: PENDING, overdue: OVERDUE}

  scope :with_status, ->(status) {
    return nil if status.empty?
    status = status.to_sym
    return where('draft = 1') if status == :draft
    return where('status = ?', STATUS[status]) if STATUS.has_key?(status)
    nil
  }
  # Invoices belonging to certain recurring_invoice
  scope :belonging_to, -> (r_id) {where recurring_invoice_id: r_id}


protected

  # Declare scopes for search
  def self.ransackable_scopes(auth_object = nil)
    super + [:with_status]
  end

public

  def self.status_collection
    [["Draft", :draft], ["Paid", :paid], ["Pending", :pending], ["Overdue", :overdue]]
  end

  # Public: Get a string representation of this object
  #
  # Examples
  #
  #   series = Series.new(name: "Sample Series", value: "SS").to_s
  #   Invoice.new(series: series).to_s
  #   # => "SS-(1)"
  #   invoice.number = 10
  #   invoice.to_s
  #   # => "SS-10"
  #
  # Returns a string.
  def to_s
    label = draft ? '[draft]' : number? ? number: "(#{series.next_number})"
    "#{series.value}#{label}"
  end

  # Public: Returns the status of the invoice based on certain conditions.
  #
  # Returns a symbol.
  def get_status
    if draft
      :draft
    elsif paid || gross_amount <= paid_amount
      :paid
    elsif due_date and due_date > Date.today
      :pending
    else
      :overdue
    end
  end

  # Public: Returns the amount that has not been already paid.
  #
  # Returns a double.
  def unpaid_amount
    draft ? 0.0 : gross_amount - paid_amount
  end

  # Public: Calculate totals for this invoice by iterating items and payments.
  #
  # Returns nothing.
  def set_amounts
    super
    self.paid_amount = 0
    payments.each do |payment|
      self.paid_amount += payment.amount
    end
    paid_amount_will_change!
  end

  def send_email
    # There is a deliver_later method which we could use
    InvoiceMailer.email_invoice(self).deliver_now
    self.sent_by_email = true
    self.save
  end

  protected

    # Protected: Decide whether this invoice needs an invoice number. It's true
    # when the invoice is not a draft and has no invoice number.
    #
    # Returns a boolean.
    def needs_invoice_number
      !draft and number.nil?
    end

    # Protected: Sets the invoice number to the series next number and updates
    # the series by incrementing the next_number counter.
    #
    # Returns nothing.
    def ensure_invoice_number
      self.number = series.next_number
      yield
      series.update_attribute :next_number, number + 1
    end

    # Protected: Update instance's status digit to reflect its status
    def set_status
      self.status = draft ? nil : STATUS[get_status]
    end

    def assign_originals
      super
      self.original_amounts[:paid_amount] = paid_amount
    end

    def mark_dirty_amounts
      super
      if original_amounts[:paid_amount] != paid_amount
        paid_amount_will_change!
      end
    end

end
