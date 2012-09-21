class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  has_and_belongs_to_many :taxes
end
