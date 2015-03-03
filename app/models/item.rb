class Item < ActiveRecord::Base
  belongs_to :common, touch: true
  has_and_belongs_to_many :taxes
  accepts_nested_attributes_for :taxes
end
