module SiwappSettings
  class Base
    include ActiveModel::Model

    @@keys = []

    def initialize(attributes={})
      @@keys.each do |key|
        class_eval { attr_accessor key }
        send "#{key}=", attributes[key] || Settings[key]
      end
    end

    def save_settings
      if valid?
        @@keys.each do |key|
          Settings[key] = send key
        end
        true
      else
        false
      end
    end

    def self.keys
      @@keys
    end
  end
end
