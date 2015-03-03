class Payment < ActiveRecord::Base
  belongs_to :invoice, touch: true
  validates :invoice_id, presence: true, numericality: {only_integer: true}

  after_save do
    amount = invoice.paid_amount.nil? ? 0 : invoice.paid_amount
    invoice.update_attribute(:paid_amount, amount + self.amount)
  end

  after_destroy do
    amount = invoice.paid_amount.nil? ? 0 : invoice.paid_amount
    invoice.update_attribute(:paid_amount, amount - self.amount)
  end
end
