class DashboardController < ApplicationController
  def index
    @invoices = Invoice.where(status: Invoice::STATUS[:overdue])
  end
end
