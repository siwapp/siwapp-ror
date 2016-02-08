module StiHelper
  # Single Table Inheritance Helper

  # Obtains a path dynamically. This helper is intended to be executed both
  # inside the controller class and the view. In both cases this method will
  # execute the __send__ method with the generated path method name and an
  # optional instance as parameters. This works because both the controller and
  # the view knows how to handle _path methods.
  #
  # - type: Like Invoice, RecurringInvoice, ...
  # - action: Like index, edit, ...
  # - instance: The instance object
  #
  # sti_path("Invoice")                  => "/invoices"
  # sti_path("Invoice", "edit", invoice) => "/invoices/1/edit"
  def sti_path(type, action = nil, instance = nil)
    send "#{sti_format(type, action, instance)}_path", instance
  end

  # Returns the dynamic part of the _path method that will be sent to the
  # instance.
  #
  # - type: Like Invoice, RecurringInvoice, ...
  # - action: Like index, edit, ...
  # - instance: The instance object
  #
  # Returns a string like:
  #
  # - "edit_invoice"
  # - "invoices"
  def sti_format(type, action, instance)
    action || instance ? "#{sti_format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
  end

  def sti_format_action(action)
    action ? "#{action}_" : ""
  end

  # Obtains a template name based on a type name and an action.
  #
  # Examples:
  #
  #   sti_template("Invoice", "index") => "invoices/index"
  #   sti_template("Invoice", "edit") => "invoices/edit"
  #
  # Returns the template name
  def sti_template(type, action)
    "#{type.underscore.pluralize}/#{action}"
  end

  # Transform the current controller name into a type name
  def current_type
    controller_name.classify
  end

  # Returns a "humanized" version of the current type name
  def current_type_name
    current_type.constantize.model_name.human.titleize
  end
end
