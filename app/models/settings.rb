# Object with all the settings stored in the property table
class Settings
  def initialize
    @settings = {}
    Property.all.each do |property|
      @settings[property.key] = property.value
    end
  end

  def method_missing(m, *args, &block)
    @settings[m.to_s]
  end
end
