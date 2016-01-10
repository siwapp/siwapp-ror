class Property < ActiveRecord::Base
  def to_s
    "#{key}: #{value}"
  end

  # Returns an object with all the settings stored in database
  def self.all_settings
    settings = {}
    Property.all.each do |property|
      settings[property.key] = property.value
    end
    settings
  end
end
