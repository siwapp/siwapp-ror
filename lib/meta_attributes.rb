module MetaAttributes

  def get_meta(key)
    if self.meta_attributes?
      attributes = ActiveSupport::JSON.decode(self.meta_attributes)
      attributes[key]
    end
  end

  def set_meta(key, value)
    if self.meta_attributes?
      attributes = ActiveSupport::JSON.decode(self.meta_attributes)
    else
      attributes = {}
    end
    if key != ""
      attributes[key] = value
      attributes = ActiveSupport::JSON.encode(attributes)
      self.meta_attributes = attributes
      self.save
    end
  end

  def delete_meta(key)
    attr_hash = self.meta
    attr_hash.delete key
    set_meta_multi attr_hash
  end

  def set_meta_multi(attr_hash)
    attributes = {}
    attr_hash.each do |key, value|
      if key != ""
        attributes[key] = value
      end
    end
    self.meta_attributes = ActiveSupport::JSON.encode(attributes)
    self.save
  end

  def meta()
    if self.meta_attributes?
      return ActiveSupport::JSON.decode(self.meta_attributes)
    else
      return {}
    end
  end

  # To include class methods into the models
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Returns a list of unique meta_attributes keys in the whole
    # collection of objects
    def meta_attributes_keys(results=self.all)
      keys = Set.new []
      results.each do |i|
        i.meta.keys.each do |key|
          keys.add(key)
        end
      end
      keys.to_a
    end
  end

end
