class Template < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true
  validates :template, presence: true

  def to_s
    name
  end

  def self.get_all
    self.where()
  end
end
