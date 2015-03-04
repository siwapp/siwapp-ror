class Tax < ActiveRecord::Base
  has_and_belongs_to_many :items, touch: true

  validates :name, presence: true
  validates :value, presence: true, numericality: true
  validates :is_default, uniqueness: { if: :is_default }

  def to_s
    name
  end
end
