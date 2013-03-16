class PaymentsController < ApplicationController
  # GET /invoices/:invoice_id/payments
  # GET /invoices/:invoice_id/payments.json
  def index
    @invoice = Invoice.find(params[:invoice_id])
    @payments = @invoice.payments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  # GET /invoices/:invoice_id/invoice_items/new
  # GET /invoices/:invoice_id/invoice_items/new.json
  def new
    @invoice = Invoice.find(params[:invoice_id])
    @payment = @invoice.payments.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end
  # GET /invoices/:invoice_id/payments/:id/edit
  def edit
    @invoice = Invoice.find(params[:invoice_id])
    @payment = Payment.find(params[:id])
  end

  # POST /invoices/:invoice_id/payments
  # POST /invoices/:invoice_id/payments.json
  def create
    @invoice = Invoice.find(params[:invoice_id])
    @payment = Payment.new(params[:payment])
    respond_to do |format|
      if @payment.save
        format.html { redirect_to invoice_payments_url(@invoice), notice: 'Payment was succesfully created.'}
        format.json { render json: @payment, status: :created, location: @payment }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/:invoice_id/invoice_items/:id
  # PUT /invoices/:invoice_id/invoice_items/:id.json
  def update
    @payment = Payment.find params[:id]
    @invoice = Invoice.find params[:invoice_id]

    respond_to do |format|
      if @payment.update_attributes params[:payment]
        format.html { redirect_to invoice_payments_url(@invoice), 
          notice: 'Payment was successfully updated.' }
        format.json {head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payment.errors, 
          status: :unprocessable_entity}
      end
    end
  end

  # DELETE /invoices/:invoice_id/payments/:id
  # DELETE /invoices/:invoice_id/payments/:id.json
  def destroy
    @invoice = Invoice.find params[:invoice_id]
    @payment = Payment.find params[:id]
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to invoice_payments_url() }
      format.json {head :no_content }
    end
  end
end
