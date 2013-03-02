class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  has_and_belongs_to_many :taxes, class_name: 'Tax'
  attr_accessible :invoice_id, :description, :discount, :quantity, :unitary_cost, :tax_ids
  
  validates :discount, :quantity, :unitary_cost, :numericality => true
  validates :description, :presence => true


  def base_amount
    self.unitary_cost * self.quantity
  end

  def net_amount
    self.base_amount - self.discount_amount
  end

  def discount_amount
    self.base_amount * self.discount / 100
  end

  def tax_amount tax_name=nil
    self.net_amount * taxes_percent(tax_name)/100
  end

  def gross_amount
    self.net_amount + self.tax_amount
  end

  def taxes_percent tax_name=nil
    taxes.select do |t| 
      t.active && 
        (tax_name ? tax_name.parameterize == t.name.parameterize: true )
    end.each.inject(0) {|sum, t| sum += t.value}
  end

end
