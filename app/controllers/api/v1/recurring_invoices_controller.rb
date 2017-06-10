class Api::V1::RecurringInvoicesController < Api::V1::CommonsController
  include CommonsControllerMixin

  set_pagination_headers :recurring_invoices, only: [:index]

  def set_listing instances
    @recurring_invoices = instances
    render json: @recurring_invoices
  end

end
