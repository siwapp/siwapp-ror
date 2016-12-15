def build_common_as(model, **kwargs)
  kwargs[:name] = "A Customer" unless kwargs.has_key? :name
  kwargs[:identification] = "123456789Z" unless kwargs.has_key? :identification
  kwargs[:series] = Series.new(value: "A") unless kwargs.has_key? :series

  common = model.new(**kwargs)
  common.set_amounts
  common
end
