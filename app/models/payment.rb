class Payment < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :invoice, touch: true  # "touch" changes invoice's updated_at on save
  validates :invoice_id, presence: true, numericality: {only_integer: true}

  def to_jbuilder
    Jbuilder.new do |json|
      json.(self, :date, :amount, :notes)
    end
  end

end
