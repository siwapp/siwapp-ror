class Tax < ActiveRecord::Base
  acts_as_paranoid
  has_and_belongs_to_many :items, touch: true
  before_destroy :has_items

  validates :name, presence: true
  validates :value, presence: true, numericality: true

  private

  def has_items
    if items.count > 0
      errors.add(:base, "Can not delete a tax which is used in some invoices")
      return false
    end
  end

  public

  def to_s
    name
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, *(attribute_names - ["deleted_at"]))
    end
  end

end
