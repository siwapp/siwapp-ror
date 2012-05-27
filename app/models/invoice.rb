class Invoice < ActiveRecord::Base
  has_many :invoice_items, :dependent => :destroy
  attr_accessible :base_amount, :customer_email, :customer_identification, :customer_name
end
