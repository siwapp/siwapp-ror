class CommonsController < ApplicationController
  include ApplicationHelper
  include CommonsControllerMixin
  include MetaAttributesControllerMixin

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
    @tags = tags_for('Common')

    # To redirect to the index with the current search params
    set_redirect_address(request.original_fullpath, @type)

    # If there is meta param, it's allowed filtering by meta_attributes
    # the format is:
    #   key1:value1,key2:value2
    #   key1, ... (if you only search for invoices having key1 no matter value)
    if params[:meta]
      conditions = []
      params[:meta].split(',').each do |condition_string|
        condition_list = condition_string.split ':'
        if condition_list.length == 1
          conditions.push("meta_attributes ilike '%#{condition_list[0]}%'")
        elsif condition_list.length == 2
          conditions.push("meta_attributes ilike '%\"#{condition_list[0]}\":\"#{condition_list[1]}\"%'")
        end
      end
      @results = @results.where(conditions.join(" and "))
    end

    set_listing @results.paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.html { render sti_template(@type, action_name), layout: 'infinite-scrolling' }
      format.csv do
        set_csv_headers("#{@type.underscore.downcase.pluralize}.csv")
        self.response_body = model.csv @results
        response.status = 200
      end
    end
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
        format.html { redirect_to redirect_address(@type), notice: "#{type_label} was successfully created." }
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
        format.html { redirect_to redirect_address(@type), notice: "#{type_label} was successfully updated." }
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
      format.html { redirect_to redirect_address(@type), notice: "#{type_label} was successfully destroyed." }
    end
  end

  # GET /commons/amounts
  #
  # Calculates the amounts totals
  def amounts
    @common = Invoice.new(amounts_params) # TODO: test
    @precision = @common.currency_precision
    @common.set_amounts # they may have changed in the form
    respond_to do |format|
      format.js
      format.json
    end
  end


  private

  # Private: sets templates and tags for some actions
  def set_extra_stuff
    @templates = Template.all
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

  def common_params
    [
      :series_id,
      :currency,

      :customer_id,
      :identification,
      :name,
      :email,
      :contact_person,
      :invoicing_address,
      :shipping_address,
      :terms,
      :notes,
      :draft,

      items_attributes: [
        :id,
        :description,
        :quantity,
        :unitary_cost,
        :discount,
        {:tax_ids => []},
        :_destroy
      ],

      tag_list: []
    ]
  end


end
