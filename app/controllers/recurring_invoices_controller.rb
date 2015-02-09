class RecurringInvoicesController < ApplicationController

  # GET /recurring_invoices
  def index
  end

  # GET /recurring_invoices/new
  def new
    @recurring_invoice = RecurringInvoice.new
  end

  # POST /recurring_invoices
  def create
    @recurring_invoice = RecurringInvoice.new(recurring_invoice_params)

    if @recurring_invoice.save
      flash[:notice] = "Recurring Invoice was successfully created."
      redirect_to @recurring_invoice
    else
      flash[:alert] = "Recurring Invoice has not been created."
      render "new"
    end

  end

  def show
    @recurring_invoice = RecurringInvoice.find(params[:id])
  end


  private

    def recurring_invoice_params
      params.require(:recurring_invoice).permit(:customer_name, :customer_email, \
                                                :due_date, :invoicing_address, \
                                                :draft, :number)
    end

end
