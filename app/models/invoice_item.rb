class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  has_and_belongs_to_many :taxes, class_name: 'Tax'
  attr_accessible :invoice_id, :description, :discount, :quantity, :unitary_cost, :tax_ids
  
  validates :discount, :quantity, :unitary_cost, :numericality => true
  validates :description, :presence => true

  def base_amount
    if self.unitary_cost and self.quantity
      self.unitary_cost * self.quantity
    else
      0
    end
  end

  def net_amount
    if self.base_amount and self.discount_amount
      self.base_amount - self.discount_amount
    else
      0
    end
  end

  def discount_amount
    if self.base_amount and self.discount
      self.base_amount * self.discount / 100
    else
      0
    end
  end

end
