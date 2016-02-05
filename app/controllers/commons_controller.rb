class CommonsController < ApplicationController
  include StiHelper

  before_action :set_type
  before_action :configure_search
  before_action :set_model_instance, only: [:show, :edit, :update, :destroy]
  before_action :set_extra_stuff, only: [:new, :create, :edit, :update]
  # TODO (@ecoslado) Make the tests to work with login_required activated
  # before_action :login_required

  # GET /commons
  # GET /commons.json
  def index
    # TODO: check https://github.com/activerecord-hackery/ransack/issues/164
    results = @search.result(distinct: true)
    results = results.tagged_with(params[:tags].split(/\s*,\s*/)) if params[:tags].present?

    @gross = results.sum :gross_amount
    @net = results.sum :net_amount
    @tax = results.sum :tax_amount
    # series has ti be included after totals calculations
    results = results.includes :series

    set_listing results.paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.html { render sti_template(@type, action_name), layout: 'infinite-scrolling' }
      format.json
    end
  end

  # GET /commons/new
  def new
    set_instance model.new
    render sti_template(@type, action_name)
  end

  # POST /commons
  # POST /commons.json
  def create
    set_instance model.new(type_params)
    respond_to do |format|
      if get_instance.save
        # if there is no customer associated then create a new one
        if type_params[:customer_id] == ''
          customer = Customer.create(
            :name => type_params[:name],
            :identification => type_params[:identification],
            :email => type_params[:email],
            :contact_person => type_params[:contact_person],
            :invoicing_address => type_params[:invoicing_address],
            :shipping_address => type_params[:shipping_address]
          )
          get_instance.update(:customer_id => customer.id)
        end
        # Redirect to index
        format.html { redirect_to sti_path(@type), notice: "#{type_label} was successfully created." }
        format.json { render sti_template(@type, :show), status: :created, location: get_instance }  # TODO: test
      else
        flash[:alert] = "#{type_label} has not been created."
        format.html { render sti_template(@type, :new) }
        # format.json { render json: @common.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /commons/1
  # GET /commons/1.json
  def show
    render sti_template(@type, action_name)
  end

  # GET /commons/1/edit
  def edit
    render sti_template(@type, action_name)
  end

  # PATCH/PUT /commons/1
  # PATCH/PUT /commons/1.json
  def update
    respond_to do |format|
      if get_instance.update(type_params)
        # Redirect to index
        format.html { redirect_to sti_path(@type), notice: "#{type_label} was successfully updated." }
        format.json { render sti_template(@type, :show), status: :ok, location: get_instance }  # TODO: test
      else
        flash[:alert] = "#{type_label} has not been saved."
        format.html { render sti_template(@type, :edit) }
        format.json { render json: get_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commons/1
  # DELETE /commons/1.json
  def destroy
    get_instance.destroy
    respond_to do |format|
      format.html { redirect_to sti_path(@type), notice: "#{type_label} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # DELETE /commons
  # bulk deletes selected elements on list
  def remove
    ids = params["#{model.name.underscore}_ids"]
    if ids.is_a?(Array) && ids.length > 0
      model.where(id: params["#{model.name.underscore}_ids"]).destroy_all
      flash[:info] = "Successfully deleted #{ids.length} #{type_label}"
    end
    redirect_to sti_path(@type)
  end

  # GET /commons/amounts
  #
  # Calculates the amounts totals
  def amounts
    @common = Invoice.new(amounts_params) # TODO: test
    @common.set_amounts

    respond_to do |format|
      format.js
      format.json
    end
  end

  protected

  # Protected: configures search
  #
  # Sets @search to be used with search_form_for.
  # Set @search_filters to true in children controllers to load the
  # advanced search filters partial located at views/<controller>/.
  #
  # Returns the same value received
  def configure_search
    @search = model.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @search_filters = false
  end

  # Protected: set an instance variable for a list of items of the current model
  #
  # Must be overriden in children controllers.
  #
  # Returns the same value received
  def set_listing(instances)
    @commons = instances
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
  def type_params
    params
      .require(model.name.underscore.to_sym)
      .permit(send("#{model.name.underscore}_params"))
  end

  private


  def login_required
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url # halts request cycle
    end
  end

  # Private: callback to set the instance object that most of the actions use.
  #
  # Returns the instance or a redirection to the index action
  def set_model_instance
    set_instance model.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The #{type_label} you were looking for could not be found."
    redirect_to sti_path(@type)
  end

  # Private: sets taxes and series for some actions
  def set_extra_stuff
    @taxes = Tax.where active: true
    @default_taxes_ids = @taxes.find_all { |t| t.is_default }.collect{|t| t.id }
    @series = Series.where enabled: true
    @tags = commons_tags
  end

  # Private: whitelist of parameters that can be used to calculate amounts
  def amounts_params
    params.require(model.name.underscore.to_sym).permit(
      items_attributes: [
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []},
        :_destroy
      ],
      payments_attributes: [
        :amount,
        :_destroy
      ]
    )
  end

  # Private: get all tags used with Common class and children classes
  #
  # Returns a list of tag names
  def commons_tags
    tag_ids = ActsAsTaggableOn::Tagging
      .where(taggable_type: 'Common', context: :tags)
      .collect(&:tag_id)
      .uniq
    ActsAsTaggableOn::Tag
      .where(id: tag_ids)
      .collect(&:name)
  end

end
