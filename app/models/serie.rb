class Serie < ActiveRecord::Base
  has_many :commons
  validates :value, presence: true

  # Public: Get a string representation of this object
  #
  # Examples
  #
  #   Serie.new(name: "Sample Series", value: "SS").to_s
  #   # => "Sample Series (SS)"
  #
  # Returns a string representation of this object
  def to_s
    "#{name} (#{value})"
  end
end
