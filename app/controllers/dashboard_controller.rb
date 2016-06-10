class DashboardController < ApplicationController
  def index
    @invoices = Invoice.with_status(:overdue)
  end
end
