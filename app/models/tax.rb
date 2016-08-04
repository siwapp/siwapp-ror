class Tax < ActiveRecord::Base
  acts_as_paranoid
  has_and_belongs_to_many :items, touch: true

  validates :name, presence: true
  validates :value, presence: true, numericality: true

  def to_s
    name
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, *(attribute_names - ["deleted_at"]))
    end
  end

end
