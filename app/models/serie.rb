class Serie < ActiveRecord::Base
  has_many :commons
  validates :value, presence: true

  def to_s
    "#{name} (#{value})"
  end
end
