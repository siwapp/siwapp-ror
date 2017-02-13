class Series < ActiveRecord::Base
  acts_as_paranoid
  has_many :commons, :dependent => :restrict_with_error
  validates :value, presence: true

  # Public: Get a string representation of this object
  #
  # Examples
  #
  #   Series.new(name: "Sample Series", value: "SS").to_s
  #   # => "Sample Series (SS)"
  #
  # Returns a string representation of this object
  def to_s
    return value if name.empty?
    name
  end

  def next_number
    invoice = commons.where(type: Invoice, draft: false).order(:number).last
    if invoice
      invoice.number + 1
    else
      first_number
    end
  end
end
