class Serie < ActiveRecord::Base
  has_many :commons
  validates :value, presence: true

  def to_s
    "#{name} (#{value})"
  end

  def next_number
    invoices = commons.where(type: :invoice).order(number: 'desc').limit(1)
    invoices.any? ? invoices[0].number + 1 : first_number
  end
end
