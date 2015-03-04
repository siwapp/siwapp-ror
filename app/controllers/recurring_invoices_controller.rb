class RecurringInvoicesController < ApplicationController
  before_action :set_recurring_invoice, only: [:show, :edit, :update, :destroy]
  before_action :set_extra_stuff, only: [:new, :edit, :create, :update]

  # GET /recurring_invoices
  def index
    @recurring_invoices = RecurringInvoice.paginate(page: params[:page], per_page: 20)
      .order(number: :desc)

    respond_to do |format|
      format.html
      format.js
    end
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
  end

  def edit
  end

  def update
    if @recurring_invoice.update(recurring_invoice_params)
      flash[:notice] = "Recurring Invoice has been updated."
      redirect_to @recurring_invoice
    else
      flash[:alert] = "Project has not been updated."
      render "edit"
    end
  end

  def destroy
    @recurring_invoice.destroy
    flash[:notice] = "Recurring Invoice has been destroyed."
    redirect_to recurring_invoices_path
  end


  private

    def recurring_invoice_params
      params
        .require(:recurring_invoice)
        .permit(
          :customer_name,
          :customer_email,
          :due_date,
          :invoicing_address,
          :draft,
          :starting_date,
          :finishing_date
        )
    end

    def set_recurring_invoice
      @recurring_invoice = RecurringInvoice.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The Recurring Invoice you were looking" +
        " for could not be found."
      redirect_to recurring_invoices_path
    end

    def set_extra_stuff
      @taxes = Tax.where active:true
      @series = Serie.where enabled: true
    end
end
