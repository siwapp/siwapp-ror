class Invoice < ActiveRecord::Base
  has_many :invoice_items, :dependent => :destroy
  attr_accessible :customer_name, :customer_identification, \
    :customer_email, :invoicing_address, :shipping_address, \
    :contact_person, :terms, :notes, :number, :issue_date, \
    :due_date
    
  accepts_nested_attributes_for :invoice_items
end
