class Common < ActiveRecord::Base
  has_many :items, dependent: :delete_all
  belongs_to :customer
  belongs_to :serie
  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true
end
