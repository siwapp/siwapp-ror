class Invoice < Common
  belongs_to :recurring_invoice
  has_many :payments, dependent: :delete_all
  accepts_nested_attributes_for :payments, :reject_if => :all_blank, :allow_destroy => true

  validates :customer_email,
    format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
             message: "Only valid emails"}, allow_blank: true
  validates :number, presence: true, numericality: {only_integer: true}
  validates :serie, presence: true

  def to_s
    "#{serie.value}-#{number}"
  end

  def set_amounts
    super
    self.paid_amount = 0
    payments.each do |payment|
      self.paid_amount += payment.amount
    end
  end

  # TODO (@carlosescri): Change the set_amounts! method to update also the
  # status of the invoice (closed, status, ...)
end
