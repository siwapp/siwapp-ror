class ApplicationController < ActionController::Base
  # CSRF attacks: raise an exception.
  protect_from_forgery with: :exception

  include SessionsHelper
  include Util
  # demand authentification everywhere
  before_action :authenticate
  # available in views
  helper_method :get_currency


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

  def authenticate
    unless current_user || controller_name.eql?('sessions')
      redirect_to login_url # halts request cycle
    end
  end

end
