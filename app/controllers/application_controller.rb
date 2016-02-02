class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Private: sets the type of the object based on the current controller
  #
  # Examples:
  #   class CommonController => "Common"
  #   class InvoiceController < CommonController => "Invoice"
  #   class RecurringInvoiceController < CommonController => "RecurringInvoice"
  #
  # Returns a string with the name of the model
  def set_type
    @type = controller_name.classify
  end

  # Private: gets the constant for the current model type.
  #
  # Returns the constant that refers to the class.
  def model
    @type.constantize
  end

  # Private: obtain a "human" name for the current model type.
  #
  # Returns a string
  def type_label
    @type.underscore.humanize.titleize
  end
end
