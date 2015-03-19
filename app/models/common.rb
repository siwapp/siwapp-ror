class Common < ActiveRecord::Base
  has_many :items, dependent: :delete_all
  belongs_to :customer
  belongs_to :serie

  accepts_nested_attributes_for :items, :reject_if => :all_blank, :allow_destroy => true

  before_save :set_amounts

  def set_amounts
    self.base_amount = 0
    self.discount_amount = 0
    self.tax_amount = 0
    items.each do |item|
      self.base_amount += item.base_amount
      self.discount_amount += item.discount_amount
      self.tax_amount += item.tax_amount
    end

    self.net_amount = base_amount - discount_amount
    self.gross_amount = net_amount + tax_amount
  end

end
