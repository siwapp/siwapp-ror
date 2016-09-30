class CommonsController < ApplicationController
  include StiHelper
  include CommonsHelper
  include MetaAttributesController

  before_action :set_type
  before_action :configure_search, only: [:index, :chart_data]
  before_action :set_model_instance, only: [:show, :edit, :update, :destroy]
  before_action :set_extra_stuff, only: [:new, :create, :edit, :update]

  
  # Gets the template to display invoices
  def get_print_template
    if template = get_instance.print_template or template = Template.find_by(print_default: true) \
        or template = Template.first
      @template_url = "/#{@type.underscore.downcase.pluralize}/template/
        #{template.id}/#{@type.underscore.downcase}/#{get_instance.id}"
    else
      @template_url = ""
    end
  end

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

  def select_print_template
    redirect_to action: "print_template", invoice_id: params[:id], id: params[:invoice][:print_template_id]
  end

  # GET /commons
  # GET /customers/:customer_id/commons --> filter by customer
  def index
    # TODO: check https://github.com/activerecord-hackery/ransack/issues/164
    results = @search.result(distinct: true)
    # If there is meta param, it's allowed filtering by meta_attributes
    # the format is: 
    #   key1:value1,key2:value2
    #   key1, ...
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
      results = @search.result(distinct: true)
        .where(conditions.join(" and "))
    end
    # filter by customer
    if params[:customer_id]
      results = results.where customer_id: params[:customer_id]
      @customer = Customer.find params[:customer_id]
      @search_url = send "customer_#{@type.underscore.downcase.pluralize}_path", params[:customer_id]
    end
    results = results.tagged_with(params[:tags].split(/\s*,\s*/)) if params[:tags].present?
    @gross = results.sum :gross_amount
    @net = results.sum :net_amount
    @tax = results.sum :tax_amount

    # series has to be included after totals calculations
    results = results.includes :series

    set_listing results.paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.html { render sti_template(@type, action_name), layout: 'infinite-scrolling' }
      format.csv do
        csv_string = get_csv results
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
    instance = model.new(type_params)
    set_instance instance
    respond_to do |format|
      if get_instance.save
        set_meta instance
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
        format.json { render sti_template(@type, :show), status: :created, location: get_instance }
      else
        flash[:alert] = "#{type_label} has not been created."
        format.html { render sti_template(@type, :new) }
        format.json { render json: get_instance.errors, status: :unprocessable_entity }
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
        format.json { render sti_template(@type, :show), status: :ok, location: instance }  # TODO: test
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
    @precision = get_currency.exponent.to_int
    @common.set_amounts # they may have changed in the form
    respond_to do |format|
      format.js
      format.json
    end
  end

  private

  # Private: sets taxes and series for some actions
  def set_extra_stuff
    @taxes = Tax.where active: true
    @default_taxes_ids = @taxes.find_all { |t| t.default }.collect{|t| t.id }
    @series = Series.where enabled: true
    @default_series_id = @series.find_all { |s| s.default }.collect{|s| s.id}
    @days_to_due = Integer Settings.days_to_due
    @tags = tags_for('Common').collect(&:name)
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
