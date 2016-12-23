class CommonsController < ApplicationController
  include StiHelper
  include CommonsHelper
  include MetaAttributesController

  before_action :set_type
  before_action :configure_search, only: [:index, :chart_data]
  before_action :set_model_instance, only: [:show, :edit, :update, :destroy]
  before_action :set_extra_stuff, only: [:new, :create, :edit, :update]

  # Renders a common's template in html and pdf formats
  def print_template
    @invoice = Invoice.find(params[:invoice_id])
    @print_template = Template.find(params[:id])
    html = render_to_string :inline => @print_template.template,
      :locals => {:invoice => @invoice, :settings => Settings}
    respond_to do |format|
      format.html { render inline: html }
      format.pdf do
        pdf = @invoice.pdf(html)
        send_data(pdf,
          :filename    => "#{@invoice}.pdf",
          :disposition => 'attachment'
        )
      end
    end
  end

  # GET /commons
  # GET /customers/:customer_id/commons --> filter by customer
  def index
    # TODO: check https://github.com/activerecord-hackery/ransack/issues/164
    results = @search.result(distinct: true).order(issue_date: :desc).order(id: :desc)
    # If there is meta param, it's allowed filtering by meta_attributes
    # the format is:
    #   key1:value1,key2:value2
    #   key1, ... (if you only search for invoices having key1 no matter value)
    # TODO: I think this below should be on the model
    if params[:meta]
      conditions = []
      params[:meta].split(',').each do |condition_string|
        condition_list = condition_string.split ':'
        if condition_list.length == 1
          conditions.push("meta_attributes like '%#{condition_list[0]}%'")
        elsif condition_list.length == 2
          conditions.push("meta_attributes like '%\"#{condition_list[0]}\":\"#{condition_list[1]}\"%'")
        end
      end
      results = results.where(conditions.join(" and "))
    end
    # filter by customer
    if params[:customer_id]
      results = results.where customer_id: params[:customer_id]
      @customer = Customer.find params[:customer_id]
      @search_url = send "customer_#{@type.underscore.downcase.pluralize}_path", params[:customer_id]
    end
    results = results.tagged_with(params[:tag_list].split(/\s*,\s*/)) if params[:tag_list].present?
    # For amount totals exclude the Failed invoices
    @gross = results.where(failed: false).sum :gross_amount
    @net = results.where(failed: false).sum :net_amount
    @count = results.count

    # series has to be included after totals calculations
    results = results.includes :series

    set_listing results.paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.html { render sti_template(@type, action_name), layout: 'infinite-scrolling' }
      format.csv do
        csv_string = model.csv results
        send_data csv_string,
          :type => "text/plain",
          :filename => "#{@type.underscore.downcase.pluralize}.csv",
          :disposition => "attachment"
      end
    end
  end

  # GET /commons/new
  def new
    instance = model.new
    instance.items.new
    # default legal terms
    instance.terms = Settings.legal_terms
    set_instance instance
    render sti_template(@type, action_name)
  end

  # POST /commons
  # POST /commons.json
  def create
    set_instance model.new(type_params)
    respond_to do |format|

      if get_instance.customer.nil?
        get_instance.customer = Customer.find_by(
          :name => type_params[:name],
          :identification => type_params[:identification]
        )
      end

      if get_instance.customer.nil?
        get_instance.customer = Customer.new(
          :name => type_params[:name],
          :identification => type_params[:identification],
          :email => type_params[:email],
          :contact_person => type_params[:contact_person],
          :invoicing_address => type_params[:invoicing_address],
          :shipping_address => type_params[:shipping_address]
        )
      end

      if get_instance.save
        set_meta get_instance
        format.html { redirect_to sti_path(@type), notice: "#{type_label} was successfully created." }
      else
        flash[:alert] = "#{type_label} has not been created."
        format.html { render sti_template(@type, :new) }
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
      instance = get_instance
      set_meta instance
      if instance.update(type_params)
        # Redirect to index
        format.html { redirect_to sti_path(@type), notice: "#{type_label} was successfully updated." }
      else
        flash[:alert] = "#{type_label} has not been saved."
        format.html { render sti_template(@type, :edit) }
      end
    end
  end

  # DELETE /commons/1
  # DELETE /commons/1.json
  def destroy
    get_instance.destroy
    respond_to do |format|
      format.html { redirect_to sti_path(@type), notice: "#{type_label} was successfully destroyed." }
    end
  end

  # GET /commons/amounts
  #
  # Calculates the amounts totals
  def amounts
    @common = Invoice.new(amounts_params) # TODO: test
    @precision = currency_precision
    @common.set_amounts # they may have changed in the form
    respond_to do |format|
      format.js
      format.json
    end
  end

  protected

  def configure_search
    super
    @tags = tags_for('Common')
  end

  private

  # Private: sets taxes and series for some actions
  def set_extra_stuff
    @taxes = Tax.where active: true
    @default_taxes_ids = @taxes.find_all { |t| t.default }.collect{|t| t.id }
    @series = Series.where enabled: true
    @templates = Template.all
    @default_series_id = @series.find_all { |s| s.default }.collect{|s| s.id}
    default_email_template = Template.find_by(email_default: true)
    default_print_template = Template.find_by(print_default: true)

    if default_email_template
      @default_email_template_id = default_email_template.id
    else
      @default_email_template_id = 1
    end

    if default_print_template
      @default_print_template_id = default_print_template.id
    else
      @default_print_template_id = 1
    end
    @days_to_due = Integer Settings.days_to_due
    @tags = tags_for('Common')
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

end
