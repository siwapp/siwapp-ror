class Api::V1::CustomersController < Api::V1::BaseController
  before_action :set_type
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    @search = Customer.ransack(params[:q])
    @customers = @search.result(distinct: true).paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.json
    end
  end

  def show
  end

  def create
    @customer = Customer.new customer_params
    respond_to do |format|
      if @customer.save
        # Check if there is any meta_attribute
        if params[:meta_attributes]
          @customer.set_meta_multi params[:meta_attributes]
        elsif params[:invoice] and params[:invoice][:meta_attributes]
          @customer.set_meta_multi params[:invoice][:meta_attributes]
        end
        format.json { render :show, status: :created, location: api_v1_customer_url(@customer) }
      else
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @customer.update customer_params
        # Check if there is any meta_attribute
        if params[:meta_attributes]
          @customer.set_meta_multi params[:meta_attributes]
        elsif params[:invoice] and params[:invoice][:meta_attributes]
          @customer.set_meta_multi params[:invoice][:meta_attributes]
        end
        format.json { render :show, status: :ok, location: api_v1_customer_url(@customer)}
      else
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @customer.destroy
        format.json { head :no_content }
      else
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_customer
    @customer = Customer.find params[:id]
  end

  def customer_params
    params.require(:customer).permit(:name, :identification, :email, :contact_person,
                                     :invoicing_address, :shipping_address)
  end

end
