class CommonsController < ApplicationController
  include StiHelper

  before_action :set_type
  before_action :set_model_instance, only: [:show, :edit, :update, :destroy]
  before_action :set_extra_stuff, only: [:new, :create, :edit, :update]

  # GET /commons
  # GET /commons.json
  def index
    set_listing model
      .includes(:serie)
      .paginate(page: params[:page], per_page: 20)
      .order(id: :desc)

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
        format.html { redirect_to sti_path(@type, get_instance), notice: "#{type_label} was successfully created." }
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
        format.html { redirect_to sti_path(@type, get_instance), notice: "#{type_label} was successfully updated." }
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

  # GET /commons/amounts
  #
  # Calculates the amounts totals
  def amounts
    @common = Invoice.new(amounts_params) # TODO: test
    @common.set_amounts

    respond_to do |format|
      format.js
    end
  end

  protected

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
  # Must be overriden in children controllers.
  #
  # Returns params
  def type_params
    params.require(model.name.underscore.to_sym)
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
    @series = Serie.where enabled: true
    @tags = commons_tags
  end

  # Private: whitelist of parameters that can be used to calculate amounts
  def amounts_params
    params.require(:invoice).permit(
      items_attributes: [
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []},
        :_destroy
      ],
      payments_attributes: [
        :amount,
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
