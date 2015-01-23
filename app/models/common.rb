class Common < ActiveRecord::Base
  has_many :items, dependent: :delete_all
  belongs_to :customer
  belongs_to :serie
end
