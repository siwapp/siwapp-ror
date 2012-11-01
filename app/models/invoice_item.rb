class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  has_and_belongs_to_many :taxes, class_name: 'Tax'
  attr_accessible :invoice_id, :description, :discount, :quantity, :unitary_cost, :tax_ids

  validates :discount, :quantity, :unitary_cost, :numericality => true

  def base_amount
    self.unitary_cost * self.quantity
  end

  def net_amount
    self.base_amount - self.discount_amount
  end

  def discount_amount
    self.base_amount * self.discount / 100
  end

end
