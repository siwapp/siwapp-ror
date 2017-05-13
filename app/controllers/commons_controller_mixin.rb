module CommonsControllerMixin


  protected

  # Protected: configures search
  #
  # Sets @search to be used with search_form_for.
  #
  # Returns the same value received
  def configure_search
    @search = model.ransack(params[:q])
  end

  # Protected: set an instance variable for a list of items of the current model
  #
  # Must be overriden in children controllers.
  #
  # Returns the same value received
  def set_listing(instances)
    @commons = instances
    render json: @commons
  end

  # Protected: set an instance variable for a concrete item of the current model
  #
  # Must be overriden in children controllers.
  #
  # Returns the same value received
  def set_instance(instance)
    @common = instance
  end

  # Protected: returns the instance variable for the current item
  #
  # Must be overriden in children controllers.
  #
  # Returns a model object instance
  def get_instance
    @common
  end

  # Protected: whitelist params for the current model and controller
  #
  # Needs a <type>_params() method inside the child controller:
  #
  # - InvoicesController => "invoice_params"
  # - RecurringInvoicesController => "recurring_invoice_params"
  #
  # Returns params
  def api_type_params
    res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
    if res[:meta_attributes]
      res.delete(:meta_attributes)
    end
    res
  end

  # Protected: whitelist params for the current model and controller
  #
  # Needs a <type>_params() method inside the child controller:
  #
  # - InvoicesController => "invoice_params"
  # - RecurringInvoicesController => "recurring_invoice_params"
  #
  # Returns params
  def type_params
    params
      .require(model.name.underscore.to_sym)
      .permit(send("#{model.name.underscore}_params"))
  end

  private

  # Private: callback to set the instance object that most of the actions use.
  #
  # Returns the instance or a redirection to the index action
  def set_model_instance
    set_instance model.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The #{type_label} you were looking for could not be found."
    redirect_to sti_path(@type)
  end


end
