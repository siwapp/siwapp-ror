class Api::V1::RecurringInvoicesController < Api::V1::CommonsController

  set_pagination_headers :recurring_invoices, only: [:index]

  def set_listing instances
    @recurring_invoices = instances
    render json: @recurring_invoices
  end

  def generate_invoices
    @invoices = RecurringInvoice.build_pending_invoices!
    render json: @invoices
  end

end
