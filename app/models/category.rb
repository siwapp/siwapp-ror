class Category < ActiveRecord::Base
  has_many :inventory
end
