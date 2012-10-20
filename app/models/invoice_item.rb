class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  has_and_belongs_to_many :taxes, class_name: 'Tax'
  attr_accessible :invoice_id, :description, :discount, :quantity, :unitary_cost, :tax_ids

  validates :invoice_id, :presence => true
  validates :discount, :quantity, :unitary_cost, :numericality => true
end
