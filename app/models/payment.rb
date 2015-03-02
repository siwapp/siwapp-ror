class Payment < ActiveRecord::Base
  belongs_to :invoice

  validates :invoice_id, presence: true, numericality: {only_integer: true}
end
