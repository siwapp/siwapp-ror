class Invoice < Common
  belongs_to :recurring_invoice
  validates :customer_name, presence: true
  validates :number, presence: true

  def to_s
    if serie
      "#{serie.value}#{number}"
    else
      "XXX-#{number}"
    end
  end
end
