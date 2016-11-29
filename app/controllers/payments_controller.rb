class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  def show
  end

  # GET /payments/new
  def new
    # OPTIMIZE (@carlosescri): use autocomplete or stuff like that.
    @invoices = Invoice.all
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
    # OPTIMIZE (@carlosescri): use autocomplete or stuff like that.
    @invoices = Invoice.all
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /payments/1
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:invoice_id, :date, :amount, :notes)
    end
end
