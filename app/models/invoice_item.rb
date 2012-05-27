class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :description, :discount, :quantity, :unitary_cost
end
