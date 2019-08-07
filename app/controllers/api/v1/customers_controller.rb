class Api::V1::CustomersController < Api::V1::BaseController
  before_action :set_type
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    @search = Customer.ransack(params[:q])
    @customers = @search.result.paginate(page: params[:page], per_page: 20)
    render json: @customers
  end

  def show
    @customer = Customer.find params[:id]
    render json: @customer
  end

  def create
    @customer = Customer.new customer_params
    if @customer.save
      # Check if there is any meta_attribute
      if params[:meta_attributes]
        @customer.set_meta_multi params[:meta_attributes]
      elsif params[:invoice] and params[:invoice][:meta_attributes]
        @customer.set_meta_multi params[:invoice][:meta_attributes]
      end
      render json: @customer, status: :created, location: api_v1_customer_url(@customer)
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update customer_params
      # Check if there is any meta_attribute
      if params[:meta_attributes]
        @customer.set_meta_multi params[:meta_attributes]
      elsif params[:invoice] and params[:invoice][:meta_attributes]
        @customer.set_meta_multi params[:invoice][:meta_attributes]
      end
      render json: @customer, status: :ok, location: api_v1_customer_url(@customer)
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @customer.destroy
      render json: { message: "Content deleted" }, status: :no_content
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find params[:id]
  end

  def customer_params
    res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
  end

end
