class Api::V1::PaymentsController < Api::V1::BaseController

  before_action :set_payment, only: [:show, :update, :destroy]

  # GET /api/v1/invoices/:invoice_id/payments
  def index
    @payments = Invoice.find(params[:invoice_id]).payments
    render json: @payments
  end

  # GET /api/v1/payments/:id
  def show
    @payment = Payment.find params[:id]
    render json: @payment
  end

  # POST /api/v1/invoices/:invoice_id/payments
  def create
    @payment = Payment.new payment_params
    @payment.update invoice_id: params[:invoice_id]
    if @payment.save
      render json: @payment, status: :created, location: api_v1_payment_url(@payment)
    else
      render json: {errors: @payment.errors}, status: :unprocessable_entity
    end
  end

  def update
    @payment.update payment_params
    if @payment.save
      render json: @payment, status: :ok, location: api_v1_payment_url(@payment)
    else
      render json: {errors: @payment.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @payment = Payment.find params[:id]
    @payment.destroy
    
    render json: {"message": "content deleted"}, status: :no_content
    
  end

  private

  def set_payment
    @payment = Payment.find params[:id]
  end

  def payment_params
    res = ActiveModelSerializers::Deserialization.jsonapi_parse(params, {})
  end

end
