class ApplicationController < ActionController::Base

  # CSRF attacks: raise an exception.
  protect_from_forgery with: :exception

  include SessionsHelper
  # demand authentification everywhere
  before_action :authenticate

  def default_url_options(options = {})
    {locale: I18n.locale}.merge options
  end

  # Public: return a list of tags  already saved for a certain types
  #
  # Params:
  #     type (string) the type to obtain the used tags for i.e. 'common' or 'customer'
  #
  # Returns tags rs

  def tags_for type
    tag_ids = ActsAsTaggableOn::Tagging
      .where(taggable_type: type.camelize, context: :tags)
      .collect(&:tag_id)
      .uniq
    ActsAsTaggableOn::Tag
      .where(id: tag_ids)
  end

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

  def set_csv_headers(filename)
    headers["X-Accel-Buffering"] = "no"
    headers["Cache-Control"] = "no-cache"
    headers["Content-Type"] = "text/csv; charset=utf-8"
    headers["Content-Disposition"] = %(attachment; filename="#{filename}")
  end

end
