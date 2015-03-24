class Payment < ActiveRecord::Base
  belongs_to :invoice, touch: true  # "touch" changes invoice's updated_at on save
  validates :invoice_id, presence: true, numericality: {only_integer: true}
end
