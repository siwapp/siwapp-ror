class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :estimates
  has_many :recurring_invoices
end
