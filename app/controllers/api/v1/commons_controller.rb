class Api::V1::CommonsController < Api::V1::BaseController
  include CommonsHelper
  include StiHelper

  before_action :set_type
  before_action :configure_search, only: [:index]
  before_action :set_model_instance, only: [:show, :edit, :update, :destroy]


  def show
    respond_to do |format| 
      format.json
    end
  end

  def index
    results = @search.result(distinct: true)
    if params[:customer_id]
      results = results.where(customer_id: params[:customer_id])
    end
    results = results.tagged_with(params[:tags].split(/\s*,\s*/)) if params[:tags].present?
    results = results.includes :series
    results.paginate(page: params[:page], per_page: 20)

    set_listing results.paginate(page: params[:page], per_page: 20)

  end

  def create
    set_instance model.new(type_params)
    respond_to do |format|
      if get_instance.save
        # if there is no customer associated then create a new one
        if type_params[:customer_id] == '' or !type_params.has_key? :customer_id # for API
          begin
            customer = Customer.find_by_name type_params[:name]
          rescue ActiveRecord::RecordNotFound 
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
      if get_instance.update(type_params)
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
