class CustomersController < ApplicationController
  include MetaAttributesController

  before_action :set_type
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :set_tags, only: [:new, :create, :edit, :update]

  # GET /customers
  def index
    @search = Customer.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @search_filters = true
    @customers = @search.result(distinct: true)
      .paginate(page: params[:page], per_page: 20)
    @customers = @customers.tagged_with(params[:tags].split(/\s*,\s*/)) if params[:tags].present?

    respond_to do |format|
      format.html { render :index, layout: 'infinite-scrolling' }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)
    set_meta @customer

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        set_meta @customer
        format.html { redirect_to customers_path, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    respond_to do |format|
      if @customer.destroy
        format.html { redirect_to customers_path, notice: 'Customer was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /customers/autocomplete.json
  # View to get the customer autocomplete feature editing invoices.
  def autocomplete
    @customers = Customer.order(:name).where("name LIKE ? and active = ?", "%#{params[:term]}%", true)
    respond_to do |format|
      format.json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :identification, :email, :contact_person,
                                       :invoicing_address, :shipping_address, :active, :tag_list)
    end

    def set_tags
      @tags = tags_for('Customer').collect(&:name)
    end
end
