class Payment < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :invoice
  validates :date, presence: true
  
  after_save do 
  	invoice.save
  end

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, :date, :amount, :notes)
    end
  end



end
