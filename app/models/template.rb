class Template < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true
  validates :template, presence: true

  def to_s
    name
  end

end
