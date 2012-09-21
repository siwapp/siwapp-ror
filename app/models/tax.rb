class Tax < ActiveRecord::Base
  has_and_belongs_to_many :invoice_items
end
