class Tax < ActiveRecord::Base
  attr_accessible :active, :is_default, :name, :value
  has_and_belong_to_many :invoice_items
end
