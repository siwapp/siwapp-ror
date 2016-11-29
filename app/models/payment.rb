class Payment < ActiveRecord::Base
  include Util

  acts_as_paranoid
  belongs_to :invoice
  validates :date, presence: true
  
  before_save do
    precision = get_currency.exponent.to_int
    self.amount = self.amount.round precision
  end

  after_save do 
  	invoice.save
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, :date, :amount, :notes)
    end
  end
end
