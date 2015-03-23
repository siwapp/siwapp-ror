class Item < ActiveRecord::Base
  belongs_to :common
  has_and_belongs_to_many :taxes

  accepts_nested_attributes_for :taxes

  def base_amount
    unitary_cost * quantity
  end

  def discount_amount
    base_amount * discount / 100.0
  end

  def net_amount
    base_amount - discount_amount
  end

  def effective_tax_rate
    tax_percent = 0
    taxes.each do |tax|
      tax_percent += tax.value
    end
    tax_percent
  end

  def tax_amount
    net_amount * effective_tax_rate / 100
  end

  def to_s
    description? ? description : 'No description'
  end

end
