module StiHelper
  def sti_path(type = nil, instance = nil, action = nil)
    send "#{sti_format(action, type, instance)}_path", instance
  end

  def sti_format(action, type, instance)
    action || instance ? "#{sti_format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
  end

  def sti_format_action(action)
    action ? "#{action}_" : ""
  end

  def sti_template(type, action)
    "#{type.underscore.pluralize}/#{action}"
  end
end
