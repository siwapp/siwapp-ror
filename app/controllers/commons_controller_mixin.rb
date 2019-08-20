module CommonsControllerMixin

  protected

  # Protected: configures search
  #
  # Sets @search to be used with search_form_for.
  #
  # Returns the same value received
  def configure_search
    @search = model.ransack(params[:q])

    @results = @search.result(distinct: true)\
      .order(issue_date: :desc).order(id: :desc)

    # Another query without distinct to get the sums right
    # This is because the query with distinct looks like:
    # SELECT SUM(DISTINCT "commons"."net_amount") FROM "commons" INNER JOIN "items" ...
    # and does not make the right sum
    @totals = @search.result()

    if params[:tag_list].present?
      @results = @results.tagged_with(params[:tag_list].split(/\s*,\s*/))
      @totals = @totals.tagged_with(params[:tag_list].split(/\s*,\s*/))
    end

    # filter by customer
    if params[:customer_id]
      @results = @results.where customer_id: params[:customer_id]
      @totals = @totals.where customer_id: params[:customer_id]
      @customer = Customer.find params[:customer_id]
    end

    @gross = @totals.sum :gross_amount
    @net = @totals.sum :net_amount

    @count = @results.count

    # series has to be included after totals calculations
    @results = @results.includes :series
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
  # Returns the instance
  def set_model_instance
    set_instance model.find(params[:id])
  end

end
