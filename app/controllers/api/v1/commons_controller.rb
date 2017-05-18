class Api::V1::CommonsController < Api::V1::BaseController
  include CommonsControllerMixin
  include StiHelper
  include MetaAttributesControllerMixin

  before_action :set_type
  before_action :configure_search, only: [:index]
  before_action :set_model_instance, only: [:show, :edit, :update, :destroy]


  def show
    @common = Common.find params[:id]
    render json: @common
  end

  # GET /api/v1/commons
  # GET /api/v1/customers/customer_id/commons  --> for API
  def index
    # meta attributes filtering
    if params[:meta]
      conditions = []
      params[:meta].each do |key, value|
        conditions.push("meta_attributes ilike '%\"#{key}\":\"#{value}\"%'")
      end
      @results = @results.where(conditions.join(" and "))
    end

    # Pagination
    if params[:page]
      page_number = params[:page][:number] || 1
      page_size = params[:page][:size] || 20
    else
      page_number = 1
      page_size = 20
    end
    set_listing @results.paginate(page: page_number, per_page: page_size)
  end

  def create
    instance = model.new(api_type_params)
    set_instance instance

    # if there is no customer associated then create a new one
    if api_type_params[:customer_id] == '' or !api_type_params.has_key? :customer_id # for API
      if api_type_params[:identification] and api_type_params[:identification] != ''
        # First check: by VAT_ID
        customer = Customer.find_by_identification api_type_params[:identification]
      elsif api_type_params[:name]
        # Second check: by name
        customer = Customer.where('lower(name) = ?', api_type_params[:name].downcase).first
      end

      if !customer
        customer = Customer.create(
          :name => api_type_params[:name],
          :identification => api_type_params[:identification],
          :email => api_type_params[:email],
          :contact_person => api_type_params[:contact_person],
          :invoicing_address => api_type_params[:invoicing_address],
          :shipping_address => api_type_params[:shipping_address]
        )
      end
      get_instance.update(:customer_id => customer.id)
    end

    if get_instance.save
      # Check if there is any meta_attribute
      if params[:data][:meta]
        instance.set_meta_multi params[:data][:meta]
      end

      # TODO(@ecoslado) A cleaner way to create nested objects
      # ActiveModel Serializer should offer anything
      if params[:data][:relationships]
        if params[:data][:relationships][:items]
          params[:data][:relationships][:items][:data].each do |item|
            if item[:attributes]
              inv_item = Item.new(description: item[:attributes][:description],
                quantity: item[:attributes][:quantity],
                unitary_cost: item[:attributes][:unitary_cost],
                tax_ids: item[:attributes][:tax_ids],
                discount: item[:attributes][:discount] || 0)
              instance.items << inv_item
            else
              render json: {errors: [{message: "No attributes in data object."}]}, status: :bad_request
            end
          end
        end
        if params[:data][:relationships][:payments]
          params[:data][:relationships][:payments][:data].each do |payment|
            if payment[:attributes]
              inv_payment = Payment.new(notes: payment[:attributes][:notes],
                date: payment[:attributes][:date],
                amount: payment[:attributes][:amount])

              instance.payments << inv_payment
            else
              render json: {errors: [{message: "No attributes in data object."}]}, status: :bad_request
            end
          end
        end
      end
      get_instance.save
      render json: get_instance, status: :created
    else
      render json: get_instance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /commons/1
  # PATCH/PUT /commons/1.json
  def update
    instance = get_instance

    if params[:data] and instance.update(api_type_params)
      # check for jsonapi compliant meta
      if params[:data][:meta]
        meta = instance.meta
        params[:data][:meta].each do |key, value|
          meta[key] = value
        end
        instance.set_meta_multi meta
      end

      # Redirect to index
      render json: get_instance, status: :ok
    else
      render json: get_instance.errors, status: :unprocessable_entity
    end
  end

  # DELETE /commons/1
  # DELETE /commons/1.json
  def destroy
    get_instance.destroy
    render json: { message: "Content deleted" }, status: :no_content
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

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def destroy_session
    request.session_options[:skip] = true
  end
end
