class Invoice < Common
  belongs_to :recurring_invoice
  validates :customer_email,
    format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
             message: "Only valid emails"}, allow_blank: true
  validates :number, presence: true, numericality: {only_integer: true}

  def to_s
    if serie
      "#{serie.value}#{number}"
    else
      "XXX-#{number}"
    end
  end
end
