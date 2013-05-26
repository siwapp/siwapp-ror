class Invoice < ActiveRecord::Base

  has_many :invoice_items, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  attr_accessible :customer_name, :customer_identification, \
    :customer_email, :invoicing_address, :shipping_address, \
    :contact_person, :terms, :notes, :number, :issue_date, \
    :due_date, :invoice_items_attributes, :payments_attributes

  accepts_nested_attributes_for :invoice_items, :allow_destroy => true
  accepts_nested_attributes_for :payments, :allow_destroy => true

  before_save :set_totals

  #validates_associated :invoice_items
  # these fields should be calculated, not validated
  #validates :base_amount, :discount_amount, :net_amount, \
  #  :gross_amount, :paid_amount, :tax_amount, \
  #  :numericality => true
  validates :number, :numericality => true
  #validates :closed, :sent_by_email, :inclusion => { :in => [true, false] }

  # attention. class method
  def self.search(search_term)
    where("customer_identification like :search_term or "+
          "customer_name like :search_term or "+
          "customer_email like :search_term or "+
          "contact_person like :search_term or number like :search_term", 
          {search_term: "%#{search_term}%"} )
  end

  def get_base_amount
    self.invoice_items.each.inject(0) { |sum, i| sum += i.base_amount }
  end

  def get_discount_amount
    self.invoice_items.each.inject(0) { |sum, i| sum += i.discount_amount }
  end

  def get_net_amount
    self.invoice_items.each.inject(0) { |sum, i| sum += i.net_amount }
  end

  def get_tax_amount tax_name=nil
    self.invoice_items.each.inject(0) {|sum, i| sum += i.tax_amount tax_name}
  end

  def get_gross_amount
    self.invoice_items.inject(0) {|sum, i| sum += i.gross_amount}
  end

  def get_paid_amount
    self.payments.inject(0) {|sum, p| sum += p.amount}
  end

  def get_due_amount
    self.gross_amount - self.paid_amount
  end

  def set_totals
    self.base_amount = self.get_base_amount
    self.discount_amount = self.get_discount_amount
    self.net_amount = self.get_net_amount
    self.tax_amount = self.get_tax_amount
    self.gross_amount = self.get_gross_amount
    self.paid_amount = self.get_paid_amount
  end
end
