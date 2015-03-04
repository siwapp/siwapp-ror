class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]
  before_action :set_extra_stuff, only: [:new, :edit, :create, :update]

  # GET /invoices
  # GET /invoices.json
  # GET /invoices.js
  def index
    @invoices = Invoice.paginate(page: params[:page], per_page: 20)
      .order(number: :desc)

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        flash[:alert] = "Invoice has not been created."
        format.html { render :new}
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        flash[:alert] = 'Invoice has not been saved.'
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The Invoice you were looking for could not be found."
      redirect_to recurring_invoices_path
    end

    def set_extra_stuff
      @taxes = Tax.where active: true
      @series = Serie.where enabled: true
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(
        :serie_id,
        :number,
        :due_date,

        :customer_name,
        :customer_email,

        :invoicing_address,
        :draft,

        items_attributes: [
          :id,
          :description,
          :quantity,
          :unitary_cost,
          {:tax_ids => []},
          :_destroy
        ],

        payments_attributes: [
          :id,
          :date,
          :amount,
          :notes,
          :_destroy
        ]
      )
    end
end
