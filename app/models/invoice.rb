class Invoice < ActiveRecord::Base
  has_many :invoice_items, :dependent => :destroy
  attr_accessible :customer_name, :customer_identification, \
    :customer_email, :invoicing_address, :shipping_address, \
    :contact_person, :terms, :notes, :number, :issue_date, \
    :due_date, :invoice_items_attributes
    
  accepts_nested_attributes_for :invoice_items
  
  validates_associated :invoice_items
  validates :base_amount, :discount_amount, :net_amount, \
  :gross_amount, :paid_amount, :tax_amount, :number, \
    :numericality => true
  validates :closed, :sent_by_email, :inclusion => { :in => [true, false] }
end
