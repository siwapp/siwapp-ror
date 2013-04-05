class Tax < ActiveRecord::Base
  attr_accessible :active, :is_default, :name, :value
  has_and_belongs_to_many :invoice_items

  validates :name, :presence => true
  validates :value, :numericality => true
  validates :active, :is_default, inclusion: { in: [true, false] }
end
