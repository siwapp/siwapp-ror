class Api::V1::CommonsController < Api::V1::BaseController
  include CommonsHelper
  include StiHelper
  include MetaAttributesController

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
    results = @search.result(distinct: true)
    # meta attributes filtering
    if params[:meta]
      conditions = []
      params[:meta].each do |key, value|
        conditions.push("meta_attributes like '%\"#{key}\":\"#{value}\"%'")
      end
      results = @search.result(distinct: true)
        .where(conditions.join(" and "))
    end
    if params[:customer_id]
      results = results.where(customer_id: params[:customer_id])
    end
    results = results.tagged_with(params[:tags].split(/\s*,\s*/)) if params[:tags].present?
    results = results.includes :series
    results.paginate(page: params[:page], per_page: 20)

    set_listing results.paginate(page: params[:page], per_page: 20)
  end

  def create
    instance = model.new(type_params)
    set_instance instance
    if get_instance.save
      # Check if there is any meta_attribute
      if params[:data][:meta_attributes]
        instance.set_meta_multi params[:meta_attributes]
      elsif params[:invoice] and params[:invoice][:meta_attributes]
        instance.set_meta_multi params[:invoice][:meta_attributes]
      end
      # TODO(@ecoslado) A cleaner way to create nested objects
      if params[:data][:relationships]
        if params[:data][:relationships][:items]
          params[:data][:relationships][:items][:data].each do |item|
            if item[:attributes]
              inv_item = Item.new(description: item[:attributes][:description],
                quantity: item[:attributes][:quantity],
                unitary_cost: item[:attributes][:unitary_cost])
              inv_item.common = instance
              inv_item.save
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
              inv_payment.invoice = instance
              inv_payment.save
            else
              render json: {errors: [{message: "No attributes in data object."}]}, status: :bad_request
            end
          end
        end
      end
      # if there is no customer associated then create a new one
      if type_params[:customer_id] == '' or !type_params.has_key? :customer_id # for API
        if type_params[:identification]
          # First check: by VAT_ID
          customer = Customer.find_by_identification type_params[:identification] 
        elsif type_params[:name]
          # Second check: by name
          customer = Customer.find_by_name type_params[:name] 
        end

        if !customer  
          customer = Customer.create(
            :name => type_params[:name],
            :identification => type_params[:identification],
            :email => type_params[:email],
            :contact_person => type_params[:contact_person],
            :invoicing_address => type_params[:invoicing_address],
            :shipping_address => type_params[:shipping_address]
          )
        end
        get_instance.update(:customer_id => customer.id)
      end
      render json: get_instance, status: :created
    else
      render json: get_instance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /commons/1
  # PATCH/PUT /commons/1.json
  def update
    respond_to do |format|
      instance = get_instance
      set_meta instance
      if instance.update(type_params)
        # Check if there is any meta_attribute
        if params[:meta_attributes]
          instance.set_meta_multi params[:meta_attributes]
        elsif params[:invoice] and params[:invoice][:meta_attributes]
          instance.set_meta_multi params[:invoice][:meta_attributes]
        end
        # Redirect to index
        render :show, status: :ok, location: get_instance
      else
        render json: get_instance.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /commons/1
  # DELETE /commons/1.json
  def destroy
    get_instance.destroy
    render json: { message: "Content deleted" }, status: :no_content
  end

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def destroy_session
    request.session_options[:skip] = true
  end
end
