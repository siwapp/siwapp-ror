class Api::V1::CommonsController < Api::V1::BaseController
  include CommonsHelper
  include StiHelper
  include MetaAttributesController

  before_action :set_type
  before_action :configure_search, only: [:index]
  before_action :set_model_instance, only: [:show, :edit, :update, :destroy]


  def show
    respond_to do |format|
      format.json
    end
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
    respond_to do |format|
      if get_instance.save
        # Check if there is any meta_attribute
        if params[:meta_attributes]
          instance.set_meta_multi params[:meta_attributes]
        elsif params[:invoice] and params[:invoice][:meta_attributes]
          instance.set_meta_multi params[:invoice][:meta_attributes]
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

        format.json { render sti_template(@type, :show), status: :created, location: get_instance }
      else
        format.json { render json: get_instance.errors, status: :unprocessable_entity }
      end
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
        format.json { render sti_template(@type, :show), status: :ok, location: get_instance }  # TODO: test
      else
        format.json { render json: get_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commons/1
  # DELETE /commons/1.json
  def destroy
    get_instance.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def destroy_session
    request.session_options[:skip] = true
  end
end
