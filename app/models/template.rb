class Template < ActiveRecord::Base
  acts_as_paranoid
  def to_s
    name
  end

end
