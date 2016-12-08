class Item < ActiveRecord::Base
  include Util

  acts_as_paranoid
  belongs_to :common
  has_and_belongs_to_many :taxes

  accepts_nested_attributes_for :taxes

  scope :unique_description, -> (term){
    order(:description).where("description LIKE ?", term).group(:description)
  }

  def base_amount
    unitary_cost * quantity
  end

  def discount_amount
    base_amount * discount / 100.0
  end

  def net_amount
    (base_amount - discount_amount).round(currency_precision)
  end

  def to_s
    description? ? description : 'No description'
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, :quantity, :discount, :description, :unitary_cost)
      json.taxes  taxes.collect { |tax| tax.to_jbuilder.attributes!}
    end
  end

end
