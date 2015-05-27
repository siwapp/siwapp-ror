class Invoice < Common
  # Relations
  belongs_to :recurring_invoice
  has_many :payments, dependent: :delete_all
  accepts_nested_attributes_for :payments, :reject_if => :all_blank, :allow_destroy => true

  # Validation
  validates :customer_email,
    format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
             message: "Only valid emails"}, allow_blank: true
  validates :series, presence: true
  validates :issue_date, presence: true
  validates :number, numericality: { only_integer: true, allow_nil: true }

  # Events
  before_save :set_status
  around_save :ensure_invoice_number, if: :needs_invoice_number

  # Status
  CLOSED = 1
  OPENED = 2
  OVERDUE = 3

  STATUS = {closed: CLOSED, opened: OPENED, overdue: OVERDUE}

  # Search
  filterrific(
    # default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [:with_series_id, :terms]
  )

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
    "#{series.value}-#{label}"
  end

  # Public: Returns the status of the invoice based on certain conditions.
  #
  # Returns a symbol.
  def get_status
    if draft
      :draft
    elsif closed || gross_amount <= paid_amount
      :closed
    elsif due_date and due_date > Date.today
      :opened
    else
      :overdue
    end
  end

  # Public: Returns the amount that has not been already paid.
  #
  # Returns a double.
  def unpaid_amount
    draft ? nil : gross_amount - paid_amount
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
      if !draft
        self.status = STATUS[get_status]
      end
    end


end
