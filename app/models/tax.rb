class Tax < ActiveRecord::Base
  attr_accessible :active, :is_default, :name, :value
end
