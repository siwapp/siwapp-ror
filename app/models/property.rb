class Property < ActiveRecord::Base

  before_save do
    if self.key == 'currency'
      Rails.cache.delete 'currency'
    end
  end

  def to_s
    "#{key}: #{value}"
  end

end
