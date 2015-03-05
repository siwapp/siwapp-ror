class Item < ActiveRecord::Base
  belongs_to :common, touch: true
  has_and_belongs_to_many :taxes

  accepts_nested_attributes_for :taxes

  def get_base_amount
    self.unitary_cost * self.quantity
  end

  def get_discount_amount
    self.get_base_amount() * self.discount / 100.0
  end

  def get_net_amount
    self.get_base_amount() - self.get_discount_amount()
  end

  def get_effective_tax_rate
    tax_percent = 0
    self.taxes.find_each do |tax|
      tax_percent += tax.is_retention ? -tax.value : tax.value
    end
    tax_percent
  end

  def get_tax_amount
    self.get_net_amount() * self.get_effective_tax_rate() / 100
  end
end
