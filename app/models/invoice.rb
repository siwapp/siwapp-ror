class Invoice < ActiveRecord::Base
  attr_accessible :base_amount, :customer_email, :customer_identification, :customer_name
end
