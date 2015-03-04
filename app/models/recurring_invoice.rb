class RecurringInvoice < Common
  has_many :invoices
  validates :customer_name, :customer_email, \
    :starting_date, presence: true
  validates :customer_email, \
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: "Only valid emails"
    }
  validate :valid_date_range
  validates :serie, presence: true

  def to_s
    "#{serie.value}"
  end

  private

  def valid_date_range
    return if starting_date.blank? || finishing_date.blank?

    if starting_date > finishing_date
      errors.add(:finishing_time, "Finishing Date must be after Starting Date")
    end
  end

end
