class CustomersController < ApplicationController
  include MetaAttributesControllerMixin
  include ApplicationHelper

  before_action :set_type
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :set_tags, only: [:index, :new, :create, :edit, :update, :destroy]

  # GET /customers
  def index
    # To redirect to the index with the current search params
    set_redirect_address(request.original_fullpath, "customers")
    @search = Customer.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @customers = @search.result
    @customers = @customers.tagged_with(params[:tag_list]) if params[:tag_list].present?

    respond_to do |format|
      format.html do
        @customers = @customers.paginate(page: params[:page],
                                         per_page: 20)
        render :index, layout: 'infinite-scrolling'
      end
      format.csv do
        set_csv_headers('customers.csv')
        self.response_body = Customer.csv @customers
      end
    end
  end

  # GET /customers/1
  def show
    redirect_to action: :edit
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
        format.html { redirect_to redirect_address("customers"), notice: 'Customer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        set_meta @customer
        # Redirect to index
        format.html { redirect_to redirect_address("customers"), notice: 'Customer was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    respond_to do |format|
      if @customer.destroy
        format.html { redirect_to redirect_address("customers"), notice: 'Customer was successfully destroyed.' }
      else
        format.html { render :edit }
      end
    end
  end

  # GET /customers/autocomplete.json
  # View to get the customer autocomplete feature editing invoices.
  def autocomplete
    @customers = Customer.order(:name).where("name ILIKE ? and active = ?", "%#{params[:term]}%", true)
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
                                       :invoicing_address, :shipping_address, :active, tag_list: [])
    end

    def set_tags
      @tags = tags_for('Customer')
    end
end
