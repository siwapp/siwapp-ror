class Invoice < Common
  belongs_to :recurring_invoice
  has_many :payments, dependent: :delete_all
  accepts_nested_attributes_for :payments, :reject_if => :all_blank, :allow_destroy => true

  validates :customer_email,
    format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
             message: "Only valid emails"}, allow_blank: true
  validates :serie, presence: true
  validates :number, numericality: { only_integer: true, allow_nil: true }
  
  before_save :set_status
  around_save :ensure_invoice_number, if: :needs_invoice_number

  # Status values
  DRAFT = 0
  CLOSED = 1
  OPENED = 2
  OVERDUE = 3

  # Public: Get a string representation of this object
  #
  # Examples
  #
  #   serie = Serie.new(name: "Sample Series", value: "SS").to_s
  #   Invoice.new(serie: serie).to_s
  #   # => "SS-(1)"
  #   invoice.number = 10
  #   invoice.to_s
  #   # => "SS-10"
  #
  # Returns a string.
  def to_s
    label = draft ? '[draft]' : number? ? number: "(#{serie.next_number})"
    "#{serie.value}-#{label}"
  end

  # Public: Returns the status of the invoice based on certain conditions.
  #
  # Returns an integer.
  def get_status
    set_amounts
    if draft
      DRAFT
    elsif closed || gross_amount <= paid_amount
      CLOSED
    elsif due_date and due_date > Date.today
      OPENED
    else
      OVERDUE
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
  # TODO (@carlosescri): Change the set_amounts! method to update also the
  # status of the invoice (closed, status, ...)
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
      self.number = serie.next_number
      yield
      serie.update_attribute :next_number, number + 1
    end

    # Protected: Update instance's status digit to reflect its status
    def set_status
      if !draft
        self.status = get_status
      end
    end


end
