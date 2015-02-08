class RecurringInvoice < Common
  has_many :invoices
  validates :customer_name, presence: true
  validates :customer_email, presence: true, \
  format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Only valid emails"}
  validates :number, presence: true, numericality: {only_integer: true}
end
