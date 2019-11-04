module SiwappSettings
  class Base
    include ActiveModel::Model

    class << self; attr_accessor :keys end
    @keys = []

    def initialize(attributes={})
      self.class.keys.each do |key|
        class_eval { attr_accessor key }
        send "#{key}=", attributes[key] || Settings.send(key)
      end
    end

    def save_settings
      if valid?
        self.class.keys.each do |key|
          value = send key
          Settings.send("#{key}=", value)
        end
        true
      else
        false
      end
    end

  end
end
