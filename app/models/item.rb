class Item < ActiveRecord::Base
  include Util

  acts_as_paranoid
  belongs_to :common
  has_and_belongs_to_many :taxes

  accepts_nested_attributes_for :taxes

  scope :unique_description, -> (term){
    order(:description).where("description LIKE ?", term).group(:description)
  }

  before_save do
    precision = get_currency.exponent.to_int
    self.unitary_cost = self.unitary_cost.round precision
  end

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
    net_amount * effective_tax_rate / 100.0
  end

  def to_s
    description? ? description : 'No description'
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, :quantity, :discount, :description, :unitary_cost)
      json.taxes  taxes.collect { |tax| tax.to_jbuilder.attributes!}
    end
  end

end
