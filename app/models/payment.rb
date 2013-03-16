class Payment < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :invoice_id, :amount, :date, :notes
  validates :amount, numericality: true
  validates :date, presence: true
end
