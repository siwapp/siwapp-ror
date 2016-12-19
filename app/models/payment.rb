class Payment < ActiveRecord::Base
  include Util

  acts_as_paranoid

  belongs_to :invoice

  validates :date, presence: true
  validates :amount, presence: true, numericality: true

  before_save do
    self.amount = self.amount.round currency_precision
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
