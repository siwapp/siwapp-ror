class RecurringInvoice < Common
  has_many :invoices
  validates :customer_name, :customer_email, :number, \
  :starting_date, :finishing_date, presence: true
  validates :customer_email, \
  format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Only valid emails"}
  validates :number, numericality: {only_integer: true}
  validate :valid_date_range

  def to_s
    if serie
      "#{serie.value}-#{number}"
    else
      "XXX-#{number}"
    end
  end

  private

  def valid_date_range
    return if starting_date.blank? || finishing_date.blank?

    if starting_date > finishing_date
      errors.add(:finishing_time, "Finishing Date must be after Starting Date")
    end
  end

end
