class Item < ActiveRecord::Base
  belongs_to :common
  has_and_belongs_to_many :taxes
  validates :description, presence: true
end
