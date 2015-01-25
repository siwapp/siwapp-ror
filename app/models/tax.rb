class Tax < ActiveRecord::Base
  has_and_belongs_to_many :items
  validates :name, presence: true

  def to_s
    name
  end
end
