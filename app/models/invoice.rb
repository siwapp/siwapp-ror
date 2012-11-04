class Invoice < ActiveRecord::Base

  has_many :invoice_items, :dependent => :destroy
  attr_accessible :customer_name, :customer_identification, \
    :customer_email, :invoicing_address, :shipping_address, \
    :contact_person, :terms, :notes, :number, :issue_date, \
    :due_date, :invoice_items_attributes

  accepts_nested_attributes_for :invoice_items, :allow_destroy => true

  #validates_associated :invoice_items
  # these fields should be calculated, not validated
  #validates :base_amount, :discount_amount, :net_amount, \
  #  :gross_amount, :paid_amount, :tax_amount, \
  #  :numericality => true
  validates :number, :numericality => true
  #validates :closed, :sent_by_email, :inclusion => { :in => [true, false] }

  def base_amount
    @base_amount ||= self.invoice_items.each.inject(0) { |sum, i| sum += i.base_amount }
  end

end
