class Common < ActiveRecord::Base
  has_many :items, dependent: :delete_all
  belongs_to :customer
  belongs_to :serie

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true

  before_save :set_amounts


  def amounts
    base = 0
    discount = 0
    tax = 0
    items.each do |it|
      base += it.base_amount
      discount += it.discount_amount
      tax += it.tax_amount
    end
    {base: base, discount: discount, tax: tax, net: base - discount, 
      gross: base - discount + tax}
  end

  def set_amounts 
    cached_amounts = amounts
    self.base_amount = cached_amounts[:base]
    self.discount_amount = cached_amounts[:discount]
    self.tax_amount = cached_amounts[:tax]
    self.net_amount = cached_amounts[:base] - cached_amounts[:discount]
    self.gross_amount = self.net_amount + cached_amounts[:tax]
    cached_amounts
  end

  def set_amounts!
    set_amounts
    save
  end
end
